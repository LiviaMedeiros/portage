# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dot-a multilib-minimal

DESCRIPTION="Libconfig is a simple library for manipulating structured configuration files"
HOMEPAGE="
	https://www.hyperrealm.com/libconfig/libconfig.html
	https://github.com/hyperrealm/libconfig
"
SRC_URI="https://github.com/hyperrealm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/15"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 sparc x86 ~x86-linux"
IUSE="+cxx debug static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="
	sys-apps/texinfo
	app-alternatives/yacc
	dev-build/libtool
"

src_prepare() {
	default

	sed -i \
		-e '/sleep 3/d' \
		configure.ac || die

	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	use static-libs && lto-guarantee-fat

	local myeconfargs=(
		$(use_enable debug asserts)
		$(use_enable cxx)
		$(use_enable static-libs static)
		$(use_enable test tests)
		--disable-examples
	)

	econf "${myeconfargs[@]}"
}

multilib_src_test() {
	# It responds to check but that does not work as intended
	emake test
}

multilib_src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	strip-lto-bytecode
}
