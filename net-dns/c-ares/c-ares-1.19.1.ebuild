# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/danielstenberg.asc
inherit edo multilib-minimal verify-sig

DESCRIPTION="C library that resolves names asynchronously"
HOMEPAGE="https://c-ares.org/"
SRC_URI="
	https://c-ares.org/download/${P}.tar.gz
	verify-sig? ( https://c-ares.org/download/${P}.tar.gz.asc )
"

LICENSE="MIT"
# Subslot = SONAME of libcares.so.2
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-danielstenberg )"

DOCS=( AUTHORS CHANGES NEWS README.md RELEASE-NOTES TODO )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ares_build.h
)

multilib_src_configure() {
	local myeconfargs=(
		--enable-nonblocking
		--enable-symbol-hiding
		$(use_enable static-libs static)
		$(use_enable test tests)
	)

	# Needed for running unit tests only
	# Violates sandbox and tests pass fine without
	export ax_cv_uts_namespace=no
	export ax_cv_user_namespace=no
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	cd "${BUILD_DIR}"/test || die

	# We're skipping the "real" network tests with the filter
	# see https://github.com/c-ares/c-ares/tree/main/test
	local network_tests=(
		# Most live tests have Live in the name
		*Live*
		# These don't but are still in ares-test-live.cc => live
		*GetTCPSock*
		*TimeoutValue*
		*GetSock*
		*GetSock_virtualized*
	)

	# The format for disabling test1, test2, and test3 looks like:
	# -test1:test2:test3
	edo ./arestest --gtest_filter=-$(echo $(IFS=:; echo "${network_tests[*]}"))
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -name "*.la" -delete || die
}
