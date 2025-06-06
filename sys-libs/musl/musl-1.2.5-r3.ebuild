# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev flag-o-matic toolchain-funcs prefix

DESCRIPTION="Light, fast and, simple C library focused on standards-conformance and safety"
HOMEPAGE="https://musl.libc.org"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.musl-libc.org/git/musl"
	inherit git-r3
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/musl.asc
	inherit verify-sig

	SRC_URI="https://musl.libc.org/releases/${P}.tar.gz"
	SRC_URI+=" verify-sig? ( https://musl.libc.org/releases/${P}.tar.gz.asc )"
	KEYWORDS="-* amd64 arm arm64 ~m68k ~mips ppc ppc64 ~riscv x86"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-musl )"
fi

GETENT_COMMIT="93a08815f8598db442d8b766b463d0150ed8e2ab"
GETENT_FILE="musl-getent-${GETENT_COMMIT}.c"
SRC_URI+="
	https://dev.gentoo.org/~blueness/musl-misc/getconf.c
	https://gitlab.alpinelinux.org/alpine/aports/-/raw/${GETENT_COMMIT}/main/musl/getent.c -> ${GETENT_FILE}
	https://dev.gentoo.org/~blueness/musl-misc/iconv.c
"

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE="crypt headers-only split-usr"

QA_SONAME="usr/lib/libc.so"
QA_DT_NEEDED="usr/lib/libc.so"
# bug #830213
QA_PRESTRIPPED="usr/lib/crtn.o"

# We want crypt on by default for this as sys-libs/libxcrypt isn't (yet?)
# built as part as crossdev. Also, elide the blockers when in cross-*,
# as it doesn't make sense to block the normal CBUILD libxcrypt at all
# there when we're installing into /usr/${CHOST} anyway.
if is_crosspkg ; then
	IUSE="${IUSE/crypt/+crypt}"
else
	RDEPEND="crypt? ( !sys-libs/libxcrypt[system] )"
	PDEPEND="!crypt? ( sys-libs/libxcrypt[system] )"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.4-arm64-crti-alignment.patch
	"${FILESDIR}"/${PN}-sched.h-reduce-namespace-conflicts.patch
	"${FILESDIR}"/${PN}-iconv-out-of-bound-fix.patch
)

just_headers() {
	use headers-only && target_is_not_host
}

pkg_setup() {
	if [[ ${CTARGET} == ${CHOST} ]] ; then
		case ${CHOST} in
			*-musl*) ;;
			*) die "Use sys-devel/crossdev to build a musl toolchain" ;;
		esac
	fi

	# Fix for bug #667126, copied from glibc ebuild:
	# make sure host make.conf doesn't pollute us
	if target_is_not_host || tc-is-cross-compiler ; then
		CHOST=${CTARGET} strip-unsupported-flags
	fi
}

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack
	elif use verify-sig ; then
		# We only verify the release; not the additional (fixed, safe) files
		# we download.
		# (Seem to get IPC error on verifying in cross?)
		! target_is_not_host && verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.asc}
	fi

	default
}

src_prepare() {
	default

	mkdir "${WORKDIR}"/misc || die
	cp "${DISTDIR}"/getconf.c "${WORKDIR}"/misc/getconf.c || die
	cp "${DISTDIR}/${GETENT_FILE}" "${WORKDIR}"/misc/getent.c || die
	cp "${DISTDIR}"/iconv.c "${WORKDIR}"/misc/iconv.c || die
}

src_configure() {
	strip-flags && filter-lto # Prevent issues caused by aggressive optimizations & bug #877343
	tc-getCC ${CTARGET}

	just_headers && export CC=true

	local sysroot
	target_is_not_host && sysroot=/usr/${CTARGET}
	./configure \
		--target=${CTARGET} \
		--prefix="${EPREFIX}${sysroot}/usr" \
		--syslibdir="${EPREFIX}${sysroot}/lib" \
		--disable-gcc-wrapper || die
}

src_compile() {
	emake obj/include/bits/alltypes.h
	just_headers && return 0

	emake
	if ! is_crosspkg ; then
		emake -C "${T}" getconf getent iconv \
			CC="$(tc-getCC)" \
			CFLAGS="${CFLAGS}" \
			CPPFLAGS="${CPPFLAGS}" \
			LDFLAGS="${LDFLAGS}" \
			VPATH="${WORKDIR}/misc"
	fi

	$(tc-getCC) ${CPPFLAGS} ${CFLAGS} -c -o libssp_nonshared.o "${FILESDIR}"/stack_chk_fail_local.c || die
	$(tc-getAR) -rcs libssp_nonshared.a libssp_nonshared.o || die
}

src_install() {
	local target="install"
	just_headers && target="install-headers"
	emake DESTDIR="${D}" ${target}
	just_headers && return 0

	# musl provides ldd via a sym link to its ld.so
	local sysroot=
	target_is_not_host && sysroot=/usr/${CTARGET}
	local ldso=$(basename "${ED}${sysroot}"/lib/ld-musl-*)
	dosym -r "${sysroot}/lib/${ldso}" "${sysroot}/usr/bin/ldd"

	if ! use crypt ; then
		# Allow sys-libs/libxcrypt[system] to provide it instead
		rm "${ED}${sysroot}/usr/include/crypt.h" || die
		rm "${ED}${sysroot}"/usr/*/libcrypt.a || die
	fi

	if ! is_crosspkg ; then
		# Fish out of config:
		#   ARCH = ...
		#   SUBARCH = ...
		# and print $(ARCH)$(SUBARCH).
		local arch=$(awk '{ k[$1] = $3 } END { printf("%s%s", k["ARCH"], k["SUBARCH"]); }' config.mak)

		# The musl build system seems to create a symlink:
		# ${D}/lib/ld-musl-${arch}.so.1 -> /usr/lib/libc.so.1 (absolute)
		# During cross or within prefix, there's no guarantee that the host is
		# using musl so that file may not exist. Use a relative symlink within
		# ${D} instead.
		rm "${ED}"/lib/ld-musl-${arch}.so.1 || die
		if use split-usr; then
			dosym ../usr/lib/libc.so /lib/ld-musl-${arch}.so.1
			# If it's still a dead symlink, OK, we really do need to abort.
			[[ -e "${ED}"/lib/ld-musl-${arch}.so.1 ]] || die
		else
			dosym libc.so /usr/lib/ld-musl-${arch}.so.1
			[[ -e "${ED}"/usr/lib/ld-musl-${arch}.so.1 ]] || die
		fi

		cp "${FILESDIR}"/ldconfig.in-r3 "${T}"/ldconfig.in || die
		sed -e "s|@@ARCH@@|${arch}|" "${T}"/ldconfig.in > "${T}"/ldconfig || die
		eprefixify "${T}"/ldconfig
		into /
		dosbin "${T}"/ldconfig
		into /usr
		dobin "${T}"/getconf
		dobin "${T}"/getent
		dobin "${T}"/iconv
		newenvd - "00musl" <<-EOF
		# 00musl autogenerated by sys-libs/musl ebuild; DO NOT EDIT.
		LDPATH="include ld.so.conf.d/*.conf"
		EOF
	fi

	if target_is_not_host ; then
		into /usr/${CTARGET}
		dolib.a libssp_nonshared.a
	else
		dolib.a libssp_nonshared.a
	fi
}

# Simple test to make sure our new musl isn't completely broken.
# Make sure we don't test with statically built binaries since
# they will fail.  Also, skip if this musl is a cross compiler.
#
# If coreutils is built with USE=multicall, some of these files
# will just be wrapper scripts, not actual ELFs we can test.
musl_sanity_check() {
	cd / #228809

	# We enter ${ED} so to avoid trouble if the path contains
	# special characters; for instance if the path contains the
	# colon character (:), then the linker will try to split it
	# and look for the libraries in an unexpected place. This can
	# lead to unsafe code execution if the generated prefix is
	# within a world-writable directory.
	# (e.g. /var/tmp/portage:${HOSTNAME})
	pushd "${ED}"/usr/$(get_libdir) >/dev/null

	# first let's find the actual dynamic linker here
	# symlinks may point to the wrong abi
	local newldso=$(find . -maxdepth 1 -name 'libc.so' -type f -print -quit)

	einfo Last-minute run tests with ${newldso} in /usr/$(get_libdir) ...

	local x striptest
	for x in cal date env free ls true uname uptime ; do
		x=$(type -p ${x})
		[[ -z ${x} || ${x} != ${EPREFIX}/* ]] && continue
		striptest=$(LC_ALL="C" file -L ${x} 2>/dev/null) || continue
		case ${striptest} in
		*"statically linked"*) continue;;
		*"static-pie linked"*) continue;;
		*"ASCII text"*) continue;;
		esac
		# We need to clear the locale settings as the upgrade might want
		# incompatible locale data.  This test is not for verifying that.
		LC_ALL=C \
		${newldso} --library-path . ${x} > /dev/null \
			|| die "simple run test (${x}) failed"
	done

	popd >/dev/null
}

pkg_preinst() {
	# Nothing to do if just installing headers
	just_headers && return

	# Prepare /etc/ld.so.conf.d/ for files
	mkdir -p "${EROOT}"/etc/ld.so.conf.d

	[[ -n ${ROOT} ]] && return 0
	[[ -d ${ED}/usr/$(get_libdir) ]] || return 0
	musl_sanity_check
}

pkg_postinst() {
	target_is_not_host && return 0

	[[ -n "${ROOT}" ]] && return 0

	ldconfig || die
}
