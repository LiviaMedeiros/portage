# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )

QA_PKGCONFIG_VERSION=$(ver_cut 1)

inherit bash-completion-r1 flag-o-matic linux-info meson-multilib ninja-utils
inherit python-single-r1 secureboot udev

DESCRIPTION="Utilities split out from systemd for OpenRC users"
HOMEPAGE="https://systemd.io/"

if [[ ${PV} == *.* ]]; then
	MY_P="systemd-stable-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/systemd/systemd-stable/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"
else
	MY_P="systemd-${PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/systemd/systemd/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"
fi

MUSL_PATCHSET="systemd-musl-patches-255.14"
SRC_URI+=" elibc_musl? ( https://dev.gentoo.org/~floppym/dist/${MUSL_PATCHSET}.tar.gz )"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+acl boot +kmod kernel-install selinux split-usr sysusers +tmpfiles test +udev ukify"
REQUIRED_USE="
	|| ( kernel-install tmpfiles sysusers udev )
	boot? ( kernel-install )
	ukify? ( boot )
	${PYTHON_REQUIRED_USE}
"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	elibc_musl? ( >=sys-libs/musl-1.2.3 )
	selinux? ( sys-libs/libselinux:0= )
	tmpfiles? (
		acl? ( sys-apps/acl:0= )
	)
	udev? (
		>=sys-apps/util-linux-2.30:0=[${MULTILIB_USEDEP}]
		sys-libs/libcap:0=[${MULTILIB_USEDEP}]
		virtual/libcrypt:=[${MULTILIB_USEDEP}]
		acl? ( sys-apps/acl:0= )
		kmod? ( >=sys-apps/kmod-15:0= )
	)
	!udev? (
		>=sys-apps/util-linux-2.30:0=
		sys-libs/libcap:0=
		virtual/libcrypt:=
	)
"
DEPEND="${COMMON_DEPEND}
	>=sys-kernel/linux-headers-3.11
"

PEFILE_DEPEND='dev-python/pefile[${PYTHON_USEDEP}]'

RDEPEND="${COMMON_DEPEND}
	boot? ( !<sys-boot/systemd-boot-250 )
	ukify? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep "${PEFILE_DEPEND}")
	)
	tmpfiles? ( !<sys-apps/systemd-tmpfiles-250 )
	udev? (
		acct-group/audio
		acct-group/cdrom
		acct-group/dialout
		acct-group/disk
		acct-group/floppy
		acct-group/input
		acct-group/kmem
		acct-group/kvm
		acct-group/lp
		acct-group/render
		acct-group/sgx
		acct-group/tape
		acct-group/tty
		acct-group/usb
		acct-group/video
		!sys-apps/gentoo-systemd-integration
		!<sys-fs/udev-250
		!sys-fs/eudev
	)
	!sys-apps/systemd
"
PDEPEND="
	udev? ( >=sys-fs/udev-init-scripts-34 )
"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	dev-util/gperf
	dev-util/patchelf
	>=sys-apps/coreutils-8.16
	sys-devel/gettext
	virtual/pkgconfig
	$(python_gen_cond_dep "
		dev-python/jinja2[\${PYTHON_USEDEP}]
		dev-python/lxml[\${PYTHON_USEDEP}]
		boot? (
			>=dev-python/pyelftools-0.30[\${PYTHON_USEDEP}]
			test? ( ${PEFILE_DEPEND} )
		)
	")
"

TMPFILES_OPTIONAL=1
UDEV_OPTIONAL=1

QA_EXECSTACK="usr/lib/systemd/boot/efi/*"
QA_FLAGS_IGNORED="usr/lib/systemd/boot/efi/.*"

CONFIG_CHECK="~BLK_DEV_BSG ~DEVTMPFS ~!IDE ~INOTIFY_USER ~!SYSFS_DEPRECATED
	~!SYSFS_DEPRECATED_V2 ~SIGNALFD ~EPOLL ~FHANDLE ~NET ~UNIX"

pkg_setup() {
	if [[ ${MERGE_TYPE} != buildonly ]] && use udev; then
		linux-info_pkg_setup
	fi
	use boot && secureboot_pkg_setup
}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/systemd-utils-255-musl-fgetxxent.patch"
	)

	if use elibc_musl; then
		PATCHES+=(
			"${WORKDIR}/${MUSL_PATCHSET}"
			"${FILESDIR}/musl-efi-wchar.patch"
		)
	fi
	default
}

src_configure() {
	python_setup
	meson-multilib_src_configure
}

multilib_src_configure() {
	local emesonargs=(
		# default is developer, bug 918671
		-Dmode=release
		-Dsysvinit-path=
		$(meson_native_use_feature boot bootloader)
		$(meson_native_use_bool kernel-install)
		$(meson_native_use_feature selinux)
		$(meson_native_use_bool sysusers)
		$(meson_use test tests)
		$(meson_native_use_bool tmpfiles)
		$(meson_use udev hwdb)
		$(meson_native_use_feature ukify)

		# Disable all optional features
		-Dadm-group=false
		-Danalyze=false
		-Dapparmor=disabled
		-Daudit=disabled
		-Dbacklight=false
		-Dbinfmt=false
		-Dbpf-framework=disabled
		-Dbzip2=disabled
		-Dcoredump=false
		-Ddbus=disabled
		-Delfutils=disabled
		-Denvironment-d=false
		-Dfdisk=disabled
		-Dgcrypt=disabled
		-Dglib=disabled
		-Dgshadow=false
		-Dgnutls=disabled
		-Dhibernate=false
		-Dhostnamed=false
		-Didn=false
		-Dima=false
		-Dinitrd=false
		-Dfirstboot=false
		-Dldconfig=false
		-Dlibcryptsetup=disabled
		-Dlibcurl=disabled
		-Dlibfido2=disabled
		-Dlibidn=disabled
		-Dlibidn2=disabled
		-Dlibiptc=disabled
		-Dlocaled=false
		-Dlogind=false
		-Dlz4=disabled
		-Dmachined=false
		-Dmicrohttpd=disabled
		-Dnetworkd=false
		-Dnscd=false
		-Dnss-myhostname=false
		-Dnss-resolve=disabled
		-Dnss-systemd=false
		-Doomd=false
		-Dopenssl=disabled
		-Dp11kit=disabled
		-Dpam=disabled
		-Dpcre2=disabled
		-Dpolkit=disabled
		-Dportabled=false
		-Dpstore=false
		-Dpwquality=disabled
		-Drandomseed=false
		-Dresolve=false
		-Drfkill=false
		-Dseccomp=disabled
		-Dsmack=false
		-Dsysext=false
		-Dtimedated=false
		-Dtimesyncd=false
		-Dtpm=false
		-Dqrencode=disabled
		-Dquotacheck=false
		-Duserdb=false
		-Dutmp=false
		-Dvconsole=false
		-Dwheel-group=false
		-Dxdg-autostart=false
		-Dxkbcommon=disabled
		-Dxz=disabled
		-Dzlib=disabled
		-Dzstd=disabled
	)

	if use tmpfiles || use udev; then
		emesonargs+=( $(meson_native_use_feature acl) )
	else
		emesonargs+=( -Dacl=disabled )
	fi

	if use udev; then
		emesonargs+=( $(meson_native_use_feature kmod) )
	else
		emesonargs+=( -Dkmod=disabled )
	fi

	if use elibc_musl; then
		# Avoid redefinition of struct ethhdr.
		append-cppflags -D__UAPI_DEF_ETHHDR=0
	fi

	if multilib_is_native_abi || use udev; then
		meson_src_configure
	fi
}

have_dmi() {
	# see dmi_arches in meson.build
	case ${CHOST} in
		mips64*)
			return 1 ;;
		aarch64*|arm*|ia64*|i?86*|loongarch64*|mips*|x86_64*)
			return 0 ;;
	esac
	return 1
}

multilib_src_compile() {
	local targets=() optional_targets=()
	if multilib_is_native_abi; then
		if use boot; then
			local efi_arch= efi_arch_alt=
			case ${CHOST} in
				aarch64*)     efi_arch=aa64 ;;
				arm*)         efi_arch=arm ;;
				loongarch32*) efi_arch=loongarch32 ;;
				loongarch64*) efi_arch=loongarch64 ;;
				riscv32*)     efi_arch=riscv32 ;;
				riscv64*)     efi_arch=riscv64 ;;
				x86_64*)      efi_arch=x64 efi_arch_alt=ia32;;
				i?86*)        efi_arch=ia32 ;;
			esac
			targets+=(
				bootctl
				man/bootctl.1
				src/boot/efi/systemd-boot${efi_arch}.efi
				src/boot/efi/linux${efi_arch}.efi.stub
				src/boot/efi/addon${efi_arch}.efi.stub
			)
			if [[ -n ${efi_arch_alt} ]]; then
				# If we have a multilib toolchain, meson.build will build the
				# "alt" arch (ia32). There's no easy way to detect this, so try
				# to build it and ignore failure.
				optional_targets+=(
					src/boot/efi/systemd-boot${efi_arch_alt}.efi
					src/boot/efi/linux${efi_arch_alt}.efi.stub
					src/boot/efi/addon${efi_arch_alt}.efi.stub
				)
			fi

		fi
		if use kernel-install; then
			targets+=(
				kernel-install
				src/kernel-install/90-loaderentry.install
				man/kernel-install.8
			)
		fi
		if use sysusers; then
			targets+=(
				systemd-sysusers
				man/sysusers.d.5
				man/systemd-sysusers.8
			)
			if use test; then
				targets+=(
					systemd-runtest.env
				)
			fi
		fi
		if use tmpfiles; then
			targets+=(
				systemd-tmpfiles
				man/tmpfiles.d.5
				man/systemd-tmpfiles.8
				tmpfiles.d/{etc,static-nodes-permissions,var}.conf
			)
			if use test; then
				targets+=(
					test-offline-passwd
					test-tmpfile-util
				)
			fi
		fi
		if use udev; then
			targets+=(
				udevadm
				systemd-hwdb
				ata_id
				cdrom_id
				fido_id
				iocost
				mtd_probe
				scsi_id
				v4l_id
				src/udev/udev.pc
				man/udev.conf.5
				man/systemd.link.5
				man/hwdb.7
				man/udev.7
				man/systemd-hwdb.8
				man/systemd-udevd.service.8
				man/udevadm.8
				man/libudev.3
				man/udev_device_get_syspath.3
				man/udev_device_has_tag.3
				man/udev_device_new_from_syspath.3
				man/udev_enumerate_add_match_subsystem.3
				man/udev_enumerate_new.3
				man/udev_enumerate_scan_devices.3
				man/udev_list_entry.3
				man/udev_monitor_filter_update.3
				man/udev_monitor_new_from_netlink.3
				man/udev_monitor_receive_device.3
				man/udev_new.3
				hwdb.d/60-autosuspend-chromiumos.hwdb
				rules.d/50-udev-default.rules
				rules.d/60-persistent-storage.rules
				rules.d/64-btrfs.rules
				# Needed for tests
				rules.d/99-systemd.rules
			)
			if have_dmi; then
				targets+=( dmi_memory_id )
			fi
			if use test; then
				targets+=(
					test-fido-id-desc
					test-link-config-tables
					test-udev-builtin
					test-udev-device-thread
					test-udev-format
					test-udev-manager
					test-udev-node
					test-udev-rule-runner
					test-udev-rules
					test-udev-spawn
					test-udev-util
				)
			fi
		fi
		if use ukify; then
			targets+=(
				ukify
				src/kernel-install/60-ukify.install
				man/ukify.1
			)
		fi
	fi
	if use udev; then
		targets+=(
			libudev
			src/libudev/libudev.pc
		)
		if use test; then
			targets+=(
				test-libudev
				test-libudev-sym
				test-udev-device-thread
			)
		fi
	fi
	if [[ ${#targets[@]} -ne 0 ]]; then
		meson_src_compile "${targets[@]}"
	fi
	if [[ ${#optional_targets[@]} -ne 0 ]]; then
		ninja ${NINJAOPTS} "${optional_targets[@]}"
	fi
}

multilib_src_test() {
	local tests=()
	if multilib_is_native_abi; then
		if use boot; then
			tests+=( --suite boot )
		fi
		if use kernel-install; then
			tests+=( --suite kernel-install )
		fi
		if use sysusers; then
			tests+=( --suite sysusers )
		fi
		if use tmpfiles; then
			tests+=( --suite tmpfiles )
		fi
		if use udev; then
			tests+=( --suite udev )
		fi
	fi
	if use udev; then
		tests+=( --suite libudev )
	fi
	if [[ ${#tests[@]} -ne 0 ]]; then
		meson_src_test --no-rebuild "${tests[@]}"
	fi
}

src_install() {
	meson-multilib_src_install
}

set_rpath() {
	patchelf --set-rpath "${EPREFIX}/usr/$(get_libdir)/systemd" "$@" || die "patchelf failed"
}

multilib_src_install() {
	if multilib_is_native_abi; then
		exeinto "/usr/$(get_libdir)/systemd"
		doexe src/shared/libsystemd-shared-${PV%%.*}.so
		if use boot; then
			set_rpath bootctl
			dobin bootctl
			doman man/bootctl.1
			meson_install --no-rebuild --tags systemd-boot
		fi
		if use kernel-install; then
			set_rpath kernel-install
			dobin kernel-install
			doman man/kernel-install.8
			exeinto /usr/lib/kernel/install.d
			doexe src/kernel-install/*.install
		fi
		if use sysusers; then
			set_rpath systemd-sysusers
			dobin systemd-sysusers
			doman man/{systemd-sysusers.8,sysusers.d.5}
		fi
		if use tmpfiles; then
			set_rpath systemd-tmpfiles
			dobin systemd-tmpfiles
			doman man/{systemd-tmpfiles.8,tmpfiles.d.5}
			insinto /usr/lib/tmpfiles.d
			doins tmpfiles.d/{etc,static-nodes-permissions,var}.conf
		fi
		if use udev; then
			set_rpath udevadm systemd-hwdb
			dobin udevadm systemd-hwdb
			dosym ../../bin/udevadm /usr/lib/systemd/systemd-udevd
			if use split-usr; then
				# elogind installs udev rules that hard-code /bin/udevadm
				dosym ../usr/bin/udevadm /bin/udevadm
			fi

			exeinto /usr/lib/udev
			set_rpath {ata_id,cdrom_id,fido_id,iocost,mtd_probe,scsi_id,v4l_id}
			doexe {ata_id,cdrom_id,fido_id,iocost,mtd_probe,scsi_id,v4l_id}

			if have_dmi; then
				set_rpath dmi_memory_id
				doexe dmi_memory_id
			fi

			rm -f rules.d/99-systemd.rules
			insinto /usr/lib/udev/rules.d
			doins rules.d/*.rules

			insinto /usr/lib/udev/hwdb.d
			doins hwdb.d/*.hwdb

			insinto /usr/share/pkgconfig
			doins src/udev/udev.pc

			doman man/{udev.conf.5,systemd.link.5,hwdb.7,systemd-hwdb.8,udev.7,udevadm.8}
			newman man/systemd-udevd.service.8 systemd-udevd.8
			doman man/libudev.3
			doman man/udev_*.3
		fi
		if use ukify; then
			dobin ukify
			dosym ../../bin/ukify /usr/lib/systemd/ukify
			doman man/ukify.1
		fi
	fi
	if use udev; then
		meson_install --no-rebuild --tags libudev
		insinto "/usr/$(get_libdir)/pkgconfig"
		doins src/libudev/libudev.pc
	fi
}

multilib_src_install_all() {
	einstalldocs
	if use boot; then
		dobashcomp shell-completion/bash/bootctl
		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/{_bootctl,_kernel-install}
	fi
	if use kernel-install; then
		exeinto /usr/lib/kernel/install.d
		doexe src/kernel-install/*.install
	fi
	if use tmpfiles; then
		doinitd "${FILESDIR}"/systemd-tmpfiles-setup
		doinitd "${FILESDIR}"/systemd-tmpfiles-setup-dev
		exeinto /etc/cron.daily
		doexe "${FILESDIR}"/systemd-tmpfiles-clean
		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/_systemd-tmpfiles
		insinto /usr/lib/tmpfiles.d
		doins tmpfiles.d/x11.conf
		doins "${FILESDIR}"/{legacy,tmp}.conf
	fi
	if use udev; then
		doheader src/libudev/libudev.h

		insinto /etc/udev
		doins src/udev/udev.conf
		keepdir /etc/udev/{hwdb.d,rules.d}

		insinto /usr/lib/systemd/network
		doins network/99-default.link

		# Remove to avoid conflict with elogind
		# https://bugs.gentoo.org/856433
		rm rules.d/70-power-switch.rules || die
		insinto /usr/lib/udev/rules.d
		doins rules.d/*.rules
		doins "${FILESDIR}"/40-gentoo.rules

		insinto /usr/lib/udev/hwdb.d
		doins hwdb.d/*.hwdb

		dobashcomp shell-completion/bash/udevadm

		insinto /usr/share/zsh/site-functions
		doins shell-completion/zsh/_udevadm
	fi

	use ukify && python_fix_shebang "${ED}"
	use boot && secureboot_auto_sign
}

add_service() {
	local initd=$1
	local runlevel=$2

	ebegin "Adding '${initd}' service to the '${runlevel}' runlevel"
	mkdir -p "${EROOT}/etc/runlevels/${runlevel}" &&
	ln -snf "${EPREFIX}/etc/init.d/${initd}" "${EROOT}/etc/runlevels/${runlevel}/${initd}"
	eend $?
}

pkg_preinst() {
	# Migrate /lib/{systemd,udev} to /usr/lib
	if use split-usr; then
		local d
		for d in systemd udev; do
			dosym ../usr/lib/${d} /lib/${d}
			if [[ -e ${EROOT}/lib/${d} && ! -L ${EROOT}/lib/${d} ]]; then
				einfo "Copying files from '${EROOT}/lib/${d}' to '${EROOT}/usr/lib/${d}'"
				cp -rpPT "${EROOT}/lib/${d}" "${EROOT}/usr/lib/${d}" || die
				einfo "Removing '${EROOT}/lib/${d}'"
				rm -r "${EROOT}/lib/${d}" || die
			fi
		done
	fi
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		add_service systemd-tmpfiles-setup-dev sysinit
		add_service systemd-tmpfiles-setup boot
	fi
	if use udev; then
		ebegin "Updating hwdb"
		systemd-hwdb --root="${ROOT}" update
		eend $?
		udev_reload
	fi
}
