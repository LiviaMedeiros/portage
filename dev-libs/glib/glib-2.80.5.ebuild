# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{10..13} )

inherit gnome.org gnome2-utils linux-info meson-multilib multilib python-any-r1 toolchain-funcs xdg

DESCRIPTION="The GLib library of C routines"
HOMEPAGE="https://www.gtk.org/"

INTROSPECTION_PN="gobject-introspection"
INTROSPECTION_PV="1.80.1"
INTROSPECTION_P="${INTROSPECTION_PN}-${INTROSPECTION_PV}"
SRC_URI="
	${SRC_URI}
	introspection? ( mirror://gnome/sources/gobject-introspection/${INTROSPECTION_PV%.*}/gobject-introspection-${INTROSPECTION_PV}.tar.${GNOME_TARBALL_SUFFIX} )
"
INTROSPECTION_SOURCE_DIR="${WORKDIR}/${INTROSPECTION_P}"
INTROSPECTION_BUILD_DIR="${WORKDIR}/${INTROSPECTION_P}-build"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="dbus debug +elf doc +introspection +mime selinux static-libs sysprof systemtap test utils xattr"
RESTRICT="!test? ( test )"

# * elfutils (via libelf) does not build on Windows. gresources are not embedded
# within ELF binaries on that platform anyway and inspecting ELF binaries from
# other platforms is not that useful so exclude the dependency in this case.
# * Technically static-libs is needed on zlib, util-linux and perhaps more, but
# these are used by GIO, which glib[static-libs] consumers don't really seem
# to need at all, thus not imposing the deps for now and once some consumers
# are actually found to static link libgio-2.0.a, we can revisit and either add
# them or just put the (build) deps in that rare consumer instead of recursive
# RDEPEND here (due to lack of recursive DEPEND).
RDEPEND="
	!<dev-libs/gobject-introspection-1.80.1
	!<dev-util/gdbus-codegen-${PV}
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/libpcre2-10.32:0=[${MULTILIB_USEDEP},unicode(+),static-libs?]
	>=dev-libs/libffi-3.0.13-r1:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	>=virtual/libintl-0-r2[${MULTILIB_USEDEP}]
	introspection? (
		>=dev-libs/gobject-introspection-common-${INTROSPECTION_PV}
	)
	kernel_linux? ( >=sys-apps/util-linux-2.23[${MULTILIB_USEDEP}] )
	selinux? ( >=sys-libs/libselinux-2.2.2-r5[${MULTILIB_USEDEP}] )
	xattr? ( !elibc_glibc? ( >=sys-apps/attr-2.4.47-r1[${MULTILIB_USEDEP}] ) )
	elf? ( virtual/libelf:0= )
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
# libxml2 used for optional tests that get automatically skipped
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	doc? ( >=dev-util/gi-docgen-2023.1 )
	dev-python/docutils
	systemtap? ( >=dev-debug/systemtap-1.3 )
	${PYTHON_DEPS}
	test? ( >=sys-apps/dbus-1.2.14 )
	virtual/pkgconfig

	introspection? (
		$(python_gen_any_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
		virtual/pkgconfig
		sys-devel/bison
		app-alternatives/lex
		${PYTHON_DEPS}
	)
"
# TODO: >=dev-util/gdbus-codegen-${PV} test dep once we modify gio/tests/meson.build to use external gdbus-codegen

PDEPEND="
	dbus? ( gnome-base/dconf )
	mime? ( x11-misc/shared-mime-info )
"
# shared-mime-info needed for gio/xdgmime, bug #409481
# dconf is needed to be able to save settings, bug #498436

MULTILIB_CHOST_TOOLS=(
	/usr/bin/gio-querymodules$(get_exeext)
)

PATCHES=(
	"${FILESDIR}"/${PN}-2.64.1-mark-gdbus-server-auth-test-flaky.patch
)

python_check_deps() {
	if use introspection ; then
		python_has_version "dev-python/setuptools[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	if use kernel_linux ; then
		CONFIG_CHECK="~INOTIFY_USER"
		if use test ; then
			CONFIG_CHECK="~IPV6"
			WARNING_IPV6="Your kernel needs IPV6 support for running some tests, skipping them."
		fi
		linux-info_pkg_setup
	fi
	python-any-r1_pkg_setup
}

src_prepare() {
	if use test; then
		# TODO: Review the test exclusions, especially now with meson
		# Disable tests requiring dev-util/desktop-file-utils when not installed, bug #286629, upstream bug #629163
		if ! has_version dev-util/desktop-file-utils ; then
			ewarn "Some tests will be skipped due dev-util/desktop-file-utils not being present on your system,"
			ewarn "think on installing it to get these tests run."
			sed -i -e "/appinfo\/associations/d" gio/tests/appinfo.c || die
			sed -i -e "/g_test_add_func/d" gio/tests/desktop-app-info.c || die
		fi

		# gdesktopappinfo requires existing terminal (gnome-terminal or any
		# other), falling back to xterm if one doesn't exist
		#if ! has_version x11-terms/xterm && ! has_version x11-terms/gnome-terminal ; then
		#	ewarn "Some tests will be skipped due to missing terminal program"
		# These tests seem to sometimes fail even with a terminal; skip for now and reevulate with meson
		# Also try https://gitlab.gnome.org/GNOME/glib/issues/1601 once ready
		# for backport (or in a bump) and file new issue if still fails
		sed -i -e "/appinfo\/launch/d" gio/tests/appinfo.c || die
		# desktop-app-info/launch* might fail similarly
		sed -i -e "/desktop-app-info\/launch-as-manager/d" gio/tests/desktop-app-info.c || die
		#fi

		# https://bugzilla.gnome.org/show_bug.cgi?id=722604
		sed -i -e "/timer\/stop/d" glib/tests/timer.c || die
		sed -i -e "/timer\/basic/d" glib/tests/timer.c || die

		ewarn "Tests for search-utils have been skipped"
		sed -i -e "/search-utils/d" glib/tests/meson.build || die

		# Play nice with network-sandbox, but this approach would defeat the purpose of the test
		#sed -i -e "s/localhost/127.0.0.1/g" gio/tests/gsocketclient-slow.c || die
	else
		# Don't build tests, also prevents extra deps, bug #512022
		sed -i -e '/subdir.*tests/d' {.,gio,glib}/meson.build || die
	fi

	# Don't build fuzzing binaries - not used
	sed -i -e '/subdir.*fuzzing/d' meson.build || die

	# gdbus-codegen is a separate package
	sed -i -e '/install_dir/d' gio/gdbus-2.0/codegen/meson.build || die
	sed -i -e '/install : true/d' gio/gdbus-2.0/codegen/meson.build || die

	# Same kind of meson-0.50 issue with some installed-tests files; will likely be fixed upstream soon
	sed -i -e '/install_dir/d' gio/tests/meson.build || die

	cat > "${T}/glib-test-ld-wrapper" <<-EOF
		#!/usr/bin/env sh
		exec \${LD:-ld} "\$@"
	EOF
	chmod a+x "${T}/glib-test-ld-wrapper" || die
	sed -i -e "s|'ld'|'${T}/glib-test-ld-wrapper'|g" gio/tests/meson.build || die

	# make default sane for us
	if use prefix ; then
		sed -i -e "s:/usr/local:${EPREFIX}/usr:" gio/xdgmime/xdgmime.c || die
		# bug #308609, without path, bug #314057
		export PERL=perl
	fi

	if [[ ${CHOST} == *-solaris* ]] ; then
		# fix standards conflicts
		sed -i \
			-e 's/\<\(_XOPEN_SOURCE_EXTENDED\)\>/_POSIX_PTHREAD_SEMANTICS/' \
			-e '/\<_XOPEN_SOURCE\>/s/\<2\>/600/' \
			meson.build || die
		sed -i -e '/#define\s\+_POSIX_SOURCE/d' \
			glib/giounix.c || die
	fi

	# disable native macOS integrations
	sed -i -e '/glib_conf.set(.HAVE_\(CARBON\|COCOA\).,/s/true/false/' \
		meson.build || die
	sed -i \
		-e '/AvailabilityMacros.h/d' \
		gio/giomodule.c || die

	# Link the glib source to the introspection subproject directory so it can be built there first
	if use introspection ; then
		ln -s "${S}" "${INTROSPECTION_SOURCE_DIR}/subprojects/glib"
	fi

	default
	gnome2_environment_reset
	# TODO: python_name sedding for correct python shebang? Might be relevant mainly for glib-utils only
}

multilib_src_configure() {
	# TODO: figure a way to pass appropriate values for all cross properties
	# that glib uses (search for get_cross_property)
	#if tc-is-cross-compiler ; then
		# https://bugzilla.gnome.org/show_bug.cgi?id=756473
		# TODO-meson: This should be in meson cross file as 'growing_stack'
		# property; and more, look at get_cross_property
		#case ${CHOST} in
		#hppa*|metag*) export glib_cv_stack_grows=yes ;;
		#*)            export glib_cv_stack_grows=no ;;
		#esac
	#fi

	# Build internal copy of gobject-introspection to avoid circular dependency (Built for native abi only)
	if multilib_native_use introspection && ! has_version ">=dev-libs/${INTROSPECTION_P}" ; then
		einfo "Bootstrapping gobject-introspection..."
		INTROSPECTION_BIN_DIR="${T}/usr/bin"
		INTROSPECTION_LIB_DIR="${T}/usr/$(get_libdir)"

		local emesonargs=(
			-Dpython="${EPYTHON}"
			-Dbuild_introspection_data=true
			# Build an internal copy of glib for the internal copy of gobject-introspection
			--force-fallback-for=glib
			# Tell meson to make paths in pkgconfig files relative, because we arent doing an actual install
			-Dpkgconfig.relocatable=true

			# We want as minimal a build as possible here to speed things up
			# and reduce the risk of failures.
			-Dglib:selinux=disabled
			-Dglib:xattr=false
			-Dglib:libmount=disabled
			-Dglib:man-pages=disabled
			-Dglib:dtrace=false
			-Dglib:systemtap=false
			-Dglib:sysprof=disabled
			-Dglib:documentation=false
			-Dglib:tests=false
			-Dglib:installed_tests=false
			-Dglib:nls=disabled
			-Dglib:oss_fuzz=disabled
			-Dglib:libelf=disabled
			-Dglib:multiarch=false
		)

		ORIG_SOURCE_DIR=${EMESON_SOURCE}
		EMESON_SOURCE=${INTROSPECTION_SOURCE_DIR}

		ORIG_BUILD_DIR=${BUILD_DIR}
		BUILD_DIR=${INTROSPECTION_BUILD_DIR}

		pushd ${INTROSPECTION_SOURCE_DIR} || die

		meson_src_configure
		meson_src_compile
		# Install to the portage temp directory so that pkgconfig relative paths resolve correctly
		meson_src_install --destdir "${T}" --skip-subprojects glib

		popd || die

		EMESON_SOURCE=${ORIG_SOURCE_DIR}
		BUILD_DIR=${ORIG_BUILD_DIR}

		# Add gobject-introspection binaries and pkgconfig files to path
		export PATH="${INTROSPECTION_BIN_DIR}:${PATH}"

		# Override primary pkgconfig search paths to prioritize our internal copy
		export PKG_CONFIG_LIBDIR="${INTROSPECTION_LIB_DIR}/pkgconfig:${INTROSPECTION_BUILD_DIR}/meson-private"

		# Set the normal primary pkgconfig search paths as secondary
		export PKG_CONFIG_PATH="$(pkg-config --variable pc_path pkg-config)"

		# Add the paths to the built glib libraries to the library path so that gobject-introspection can load them
		for gliblib in glib gobject gthread gmodule gio girepository; do
			export LD_LIBRARY_PATH="${BUILD_DIR}/${gliblib}:${LD_LIBRARY_PATH}"
		done

		# Add the paths to the gobject-introspection python modules to python path so they can be imported
		export PYTHONPATH="${INTROSPECTION_LIB_DIR}/gobject-introspection:${PYTHONPATH}"
	fi

	use debug && EMESON_BUILD_TYPE=debug

	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
		-Druntime_dir="${EPREFIX}"/run
		$(meson_feature selinux)
		$(meson_use xattr)
		-Dlibmount=enabled # only used if host_system == 'linux'
		-Dman-pages=enabled
		$(meson_use systemtap dtrace)
		$(meson_use systemtap)
		$(meson_feature sysprof)
		$(meson_use doc documentation)
		$(meson_use test tests)
		-Dinstalled_tests=false
		-Dnls=enabled
		-Doss_fuzz=disabled
		$(meson_native_use_feature elf libelf)
		-Dmultiarch=false
		$(meson_native_use_feature introspection)
	)

	# Workaround for bug #938302
	if use systemtap && has_version "dev-debug/systemtap[-dtrace-symlink(+)]" ; then
		local native_file="${T}"/meson.${CHOST}.ini.local
		cat >> ${native_file} <<-EOF || die
		[binaries]
		dtrace='stap-dtrace'
		EOF
		emesonargs+=( --native-file "${native_file}" )
	fi

	meson_src_configure
}

multilib_src_test() {
	export XDG_CONFIG_DIRS=/etc/xdg
	export XDG_DATA_DIRS=/usr/local/share:/usr/share
	# TODO: Use ${ABI} here to be unique for multilib?
	export G_DBUS_COOKIE_SHA1_KEYRING_DIR="${T}/temp"
	export LC_TIME=C # bug #411967
	export TZ=UTC
	unset GSETTINGS_BACKEND # bug #596380
	python_setup

	# https://bugs.gentoo.org/839807
	local -x SANDBOX_PREDICT=${SANDBOX_PREDICT}
	addpredict /usr/b

	# Related test is a bit nitpicking
	mkdir -p "$G_DBUS_COOKIE_SHA1_KEYRING_DIR" || die
	chmod 0700 "$G_DBUS_COOKIE_SHA1_KEYRING_DIR" || die

	meson_src_test --timeout-multiplier 20 --no-suite flaky
}

multilib_src_install() {
	meson_src_install
	keepdir /usr/$(get_libdir)/gio/modules
}

multilib_src_install_all() {
	# These are installed by dev-util/glib-utils
	# TODO: With patching we might be able to get rid of the python-any deps
	# and removals, and test depend on glib-utils instead; revisit now with
	# meson
	rm "${ED}/usr/bin/glib-genmarshal" || die
	rm "${ED}/usr/share/man/man1/glib-genmarshal.1" || die
	rm "${ED}/usr/bin/glib-mkenums" || die
	rm "${ED}/usr/share/man/man1/glib-mkenums.1" || die
	rm "${ED}/usr/bin/gtester-report" || die
	rm "${ED}/usr/share/man/man1/gtester-report.1" || die
	# gdbus-codegen manpage installed by dev-util/gdbus-codegen
	rm "${ED}/usr/share/man/man1/gdbus-codegen.1" || die
}

pkg_preinst() {
	xdg_pkg_preinst

	# Make gschemas.compiled belong to glib alone
	local cache="/usr/share/glib-2.0/schemas/gschemas.compiled"

	if [[ -e ${EROOT}${cache} ]]; then
		cp "${EROOT}"${cache} "${ED}"/${cache} || die
	else
		touch "${ED}"${cache} || die
	fi

	multilib_pkg_preinst() {
		# Make giomodule.cache belong to glib alone
		local cache="/usr/$(get_libdir)/gio/modules/giomodule.cache"

		if [[ -e ${EROOT}${cache} ]]; then
			cp "${EROOT}"${cache} "${ED}"${cache} || die
		else
			touch "${ED}"${cache} || die
		fi
	}

	# Don't run the cache ownership when cross-compiling, as it would end up with an empty cache
	# file due to inability to create it and GIO might not look at any of the modules there
	if ! tc-is-cross-compiler ; then
		multilib_foreach_abi multilib_pkg_preinst
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	# glib installs no schemas itself, but we force update for fresh install in case
	# something has dropped in a schemas file without direct glib dep; and for upgrades
	# in case the compiled schema format could have changed
	gnome2_schemas_update

	multilib_pkg_postinst() {
		gnome2_giomodule_cache_update \
			|| die "Update GIO modules cache failed (for ${ABI})"
	}
	if ! tc-is-cross-compiler ; then
		multilib_foreach_abi multilib_pkg_postinst
	else
		ewarn "Updating of GIO modules cache skipped due to cross-compilation."
		ewarn "You might want to run gio-querymodules manually on the target for"
		ewarn "your final image for performance reasons and re-run it when packages"
		ewarn "installing GIO modules get upgraded or added to the image."
	fi

	for v in ${REPLACING_VERSIONS}; do
		if ver_test "$v" "-lt" "2.63.6"; then
			ewarn "glib no longer installs the gio-launch-desktop binary. You may need"
			ewarn "to restart your session for \"Open With\" dialogs to work."
		fi
	done
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update

	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		multilib_pkg_postrm() {
			rm -f "${EROOT}"/usr/$(get_libdir)/gio/modules/giomodule.cache || die
		}
		multilib_foreach_abi multilib_pkg_postrm
		rm -f "${EROOT}"/usr/share/glib-2.0/schemas/gschemas.compiled || die
	fi
}
