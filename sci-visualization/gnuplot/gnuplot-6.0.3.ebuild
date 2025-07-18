# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1,2,3,4} )
WX_GTK_VER="3.2-gtk3"

inherit autotools lua-single readme.gentoo-r1 toolchain-funcs wxwidgets

DESCRIPTION="Command-line driven interactive plotting program"
HOMEPAGE="http://www.gnuplot.info/"

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.code.sf.net/p/gnuplot/gnuplot-main"
	EGIT_BRANCH="master"
	MY_P="${PN}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${MY_P}"
else
	MY_P="${P/_/.}"
	SRC_URI="https://downloads.sourceforge.net/gnuplot/${MY_P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="gnuplot"
SLOT="0"
IUSE="amos aqua bitmap cairo doc examples +gd gpic latex libcaca libcerf lua metafont metapost qt6 readline regis tgif wxwidgets X"

REQUIRED_USE="
	doc? ( gd )
	lua? ( ${LUA_REQUIRED_USE} )"

RDEPEND="
	amos? ( dev-libs/openspecfun )
	cairo? (
		x11-libs/cairo
		x11-libs/pango )
	gd? ( >=media-libs/gd-2.0.35-r3:2=[png] )
	latex? (
		virtual/latex-base
		lua? (
			dev-tex/pgf
			>=dev-texlive/texlive-latexrecommended-2008-r2 ) )
	libcaca? ( media-libs/libcaca )
	lua? ( ${LUA_DEPS} )
	qt6? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[gui,network,widgets]
		dev-qt/qtsvg:6 )
	readline? ( sys-libs/readline:0= )
	libcerf? ( sci-libs/libcerf:= )
	wxwidgets? (
		x11-libs/wxGTK:${WX_GTK_VER}=[X]
		x11-libs/cairo
		x11-libs/pango
		x11-libs/gtk+:3 )
	X? (
		x11-libs/libX11
		x11-libs/libXaw )"

DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		virtual/latex-base
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-langgreek
		dev-texlive/texlive-mathscience
		app-text/ghostscript-gpl )
	qt6? ( dev-qt/qttools:6[linguist] )"

IDEPEND="latex? ( virtual/latex-base )"

GP_VERSION="${PV%.*}"
TEXMF="${EPREFIX}/usr/share/texmf-site"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1-no-picins.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default

	if [[ ${PV##*.} = 9999 ]]; then
		local dir
		for dir in config demo m4 term tutorial; do
			emake -C "$dir" -f Makefile.am.in Makefile.am
		done
	fi

	# Add special version identification as required by provision 2
	# of the gnuplot license
	sed -i -e "1s/.*/& (Gentoo revision ${PR})/" PATCHLEVEL || die

	eautoreconf

	# Make sure we don't mix build & host flags.
	sed -i \
		-e 's:@CPPFLAGS@:$(BUILD_CPPFLAGS):' \
		-e 's:@CFLAGS@:$(BUILD_CFLAGS):' \
		-e 's:@LDFLAGS@:$(BUILD_LDFLAGS):' \
		-e 's:@CC@:$(CC_FOR_BUILD):' \
		docs/Makefile.in || die
}

src_configure() {
	if ! use latex; then
		sed -i -e '/SUBDIRS/s/LaTeX//' share/Makefile.in || die
	fi

	use wxwidgets && setup-wxwidgets

	tc-export CC CXX			#453174
	tc-export_build_env BUILD_CC
	export CC_FOR_BUILD=${BUILD_CC}

	local myconf=(
		--with-texdir="${TEXMF}/tex/latex/${PN}"
		--with-readline=$(usex readline gnu builtin)
		$(use_with amos)
		$(use_with bitmap bitmap-terminals)
		$(use_with cairo)
		$(use_with gd)
		$(use_with gpic)
		"$(use_with libcaca caca "${EPREFIX}/usr/$(get_libdir)")"
		$(use_with libcerf)
		$(use_with lua)
		$(use_with metafont)
		$(use_with metapost)
		$(use_with qt6 qt qt6)
		$(use_with regis)
		$(use_with tgif)
		$(use_with X x)
		--enable-stats
		$(use_enable wxwidgets)
		DIST_CONTACT="https://bugs.gentoo.org/"
		EMACS=no
		# pdflatex fails in titlepag.tex: "Argument of Â has an extra }."
		# Work around this by using lualatex to build the user manual,
		# see release notes of gnuplot-6.0.3
		PDFLATEX=lualatex
	)

	econf "${myconf[@]}"
}

src_compile() {
	# Prevent access violations #201871
	local -x VARTEXFONTS="${T}/fonts"
	# Work around luatex braindamage #950021
	local -x TEXMFCACHE="${T}/texmf-var" TEXMFVAR="${T}/texmf-var"

	emake all

	if use doc; then
		if use cairo; then
			emake -C docs pdf
		else
			ewarn "Cannot build figures unless cairo is enabled."
			ewarn "Building documentation without figures."
			emake -C docs pdf_nofig
			mv docs/nofigures.pdf docs/gnuplot.pdf || die
		fi
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc BUGS NEWS PGPKEYS README* RELEASE_NOTES
	newdoc term/PostScript/README README-ps
	newdoc term/js/README README-js
	use lua && newdoc term/lua/README README-lua

	local DOC_CONTENTS='Gnuplot no longer links against pdflib. You can
		use the "pdfcairo" terminal for PDF output.'
	use cairo || DOC_CONTENTS+=' It is available with USE="cairo".'
	use gd && DOC_CONTENTS+="\n\nFor font support in png/jpeg/gif output,
		you may have to set the GDFONTPATH and GNUPLOT_DEFAULT_GDFONT
		environment variables. See the FAQ file in /usr/share/doc/${PF}/
		for more information."
	readme.gentoo_create_doc

	if use examples; then
		# Demo files
		insinto /usr/share/${PN}/${GP_VERSION}
		doins -r demo
		rm "${ED}"/usr/share/${PN}/${GP_VERSION}/demo/binary{1,2,3} || die
		rm "${ED}"/usr/share/${PN}/${GP_VERSION}/demo/plugin/*.{o,so} || die
	fi

	if use doc; then
		# Manual, FAQ
		dodoc docs/gnuplot.pdf #FAQ.pdf
		# Documentation for making PostScript files
		docinto psdoc
		dodoc docs/psdoc/{*.doc,*.tex,*.ps,*.gpi,README}
	fi
}

src_test() {
	emake check GNUTERM="dumb"
}

pkg_postinst() {
	use latex && texmf-update
	readme.gentoo_print_elog
}

pkg_postrm() {
	use latex && texmf-update
}
