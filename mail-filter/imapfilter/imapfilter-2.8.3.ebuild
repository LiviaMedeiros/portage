# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua-single toolchain-funcs

DESCRIPTION="An IMAP mail filtering utility"
HOMEPAGE="https://github.com/lefcha/imapfilter"
SRC_URI="https://github.com/lefcha/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	dev-libs/openssl:=
	dev-libs/libpcre2
	${LUA_DEPS}"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README samples/. )

src_prepare() {
	default
	sed -i -e "/^PREFIX/s:/usr/local:${EPREFIX}/usr:" \
		-e "/^MANDIR/s:man:share/man:" \
		-e "/^CFLAGS/s:CFLAGS =:CFLAGS +=:" \
		-e "/^CFLAGS/s/-O//" \
		src/Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}" \
		INCDIRS="$(lua_get_CFLAGS)" \
		LIBLUA="$(lua_get_LIBS)"
}

src_install() {
	default
	doman doc/imapfilter.1 doc/imapfilter_config.5
}
