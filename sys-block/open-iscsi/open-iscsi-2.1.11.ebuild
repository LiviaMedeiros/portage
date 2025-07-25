# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic linux-info meson systemd toolchain-funcs udev

DESCRIPTION="A performant, transport independent, multi-platform implementation of RFC3720"
HOMEPAGE="https://www.open-iscsi.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+ GPL-2+"
SLOT="0/0.2"
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="debug infiniband +tcp rdma systemd"
REQUIRED_USE="infiniband? ( rdma ) || ( rdma tcp )"
# Tries to write to /run/lock/iscsi etc
RESTRICT="test"

DEPEND="
	dev-libs/openssl:=
	sys-apps/kmod
	sys-block/open-isns:=
	sys-kernel/linux-headers
	infiniband? ( sys-cluster/rdma-core )
	systemd? ( sys-apps/systemd:= )
"
RDEPEND="
	${DEPEND}
	sys-fs/lsscsi
	sys-apps/util-linux
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.7-fix_bitwise.patch
)

pkg_setup() {
	linux-info_pkg_setup

	# Needs to be done, as iscsid currently only starts, when having the iSCSI
	# support loaded as module. Kernel builtin options don't work. See this for
	# more information:
	# https://groups.google.com/group/open-iscsi/browse_thread/thread/cc10498655b40507/fd6a4ba0c8e91966
	# If there's a new release, check whether this is still valid!
	TCP_MODULES="SCSI_ISCSI_ATTRS ISCSI_TCP"
	RDMA_MODULES="INFINIBAND_ISER"
	INFINIBAND_MODULES="INFINIBAND_IPOIB INIBAND_USER_MAD INFINIBAND_USER_ACCESS"
	CONFIG_CHECK_MODULES="tcp? ( ${TCP_MODULES} ) rdma? ( ${RDMA_MODULES} ) infiniband? ( ${INFINIBAND_MODULES} )"
	if linux_config_exists; then
		if use tcp; then
			for module in ${TCP_MODULES}; do
				linux_chkconfig_module ${module} || ewarn "${module} needs to be built as module (builtin doesn't work)"
		done
		fi
		if use infiniband; then
			for module in ${INFINIBAND_MODULES}; do
				linux_chkconfig_module ${module} || ewarn "${module} needs to be built as module (builtin doesn't work)"
		done
		fi
		if use rdma; then
			for module in ${RDMA_MODULES}; do
				linux_chkconfig_module ${module} || ewarn "${module} needs to be built as module (builtin doesn't work)"$
			done
		fi
	fi
}

src_configure() {
	use debug && append-cppflags -DDEBUG_TCP -DDEBUG_SCSI

	# TODO: Make sys-block/open-isns optional if useful? There's an upstream
	# build system option for this already as of 2.1.9.
	local emesonargs=(
		-Dsystemddir="$(systemd_get_utildir)"
		-Drulesdir="$(get_udevdir)"/rules.d
		$(meson_use !systemd no_systemd)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# We'll regenerate this later to avoid baking the value into binary
	# packages. It doesn't get generated when cross-compiling.
	tc-is-cross-compiler || rm "${ED}"/etc/iscsi/initiatorname.iscsi || die

	docinto test/
	dodoc $(find test -maxdepth 1 -type f ! -name ".*")

	insinto /etc/iscsi
	newins "${FILESDIR}"/initiatorname.iscsi initiatorname.iscsi.example

	newconfd "${FILESDIR}"/iscsid-conf.d iscsid
	newinitd "${FILESDIR}"/iscsid-init.d iscsid

	keepdir /var/db/iscsi
	fperms 700 /var/db/iscsi
	fperms 600 /etc/iscsi/iscsid.conf
}

pkg_postinst() {
	in='/etc/iscsi/initiatorname.iscsi'
	if ! tc-is-cross-compiler && [[ ! -f "${EROOT}${in}" ]] && [[ -f "${EROOT}${in}.example" ]] ; then
		{
		  cat "${EROOT}${in}.example"
		  echo "# InitiatorName generated by ${CATEGORY}/${PF} at $(date -uR)"
		  echo "InitiatorName=$("${EROOT}"/usr/sbin/iscsi-iname)"
		} >> "${EROOT}${in}.tmp" && mv -f "${EROOT}${in}.tmp" "${EROOT}${in}"
	fi

	udev_reload
}

pkg_postrm() {
	udev_reload
}
