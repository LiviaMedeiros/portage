# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Multi-platform helper library for other libraries"
HOMEPAGE="https://www.aquamaniac.de/sites/aqbanking/index.php"
SRC_URI="https://www.aquamaniac.de/rdm/attachments/download/529/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/79" # correspond with libgwenhywfar.so version
KEYWORDS="amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="debug gtk qt5 test" # doc (is broken, bug #950614

# broken upstream, reported but got no reply
RESTRICT="test"

DEPEND="
	dev-libs/libgcrypt:0=
	dev-libs/libgpg-error
	dev-libs/libxml2:2=
	dev-libs/openssl:0=
	net-libs/gnutls:=
	virtual/libiconv
	virtual/libintl
	virtual/opengl
	gtk? ( x11-libs/gtk+:3 )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsql:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
# doc? ( app-text/doxygen )

PATCHES=(
	"${FILESDIR}"/${PN}-5.12.0-c23.patch
)

src_configure() {
	local myeconfargs=(
		--with-docpath="${EPREFIX}/usr/share/doc/${PF}/apidoc"
		--with-libxml2-code=yes
		$(use_enable debug)
		#$(use_enable doc full-doc)
	)
	use qt5 && myeconfargs+=(
		--with-qt5-moc="$(qt5_get_bindir)/moc"
		--with-qt5-qmake="$(qt5_get_bindir)/qmake"
	)

	local guis=()
	use gtk && guis+=( gtk3 )
	use qt5 && guis+=( qt5 )
	econf "${myeconfargs[@]}" "--with-guis=${guis[*]}"
}

src_compile() {
	emake
	#use doc && emake srcdoc
}

src_install() {
	default
	#use doc && emake DESTDIR="${D}" install-srcdoc
	find "${D}" -name '*.la' -type f -delete || die
}
