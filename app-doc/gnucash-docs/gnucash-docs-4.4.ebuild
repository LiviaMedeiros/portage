# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools optfeature

DESCRIPTION="Documentation package for GnuCash"
HOMEPAGE="https://www.gnucash.org/"
SRC_URI="https://github.com/Gnucash/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 FDL-1.1"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"
LOCALES=( de it ja pt )
IUSE="${LOCALES[*]/#/l10n_}"

DEPEND="
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	app-text/rarian
	dev-libs/libxml2
	dev-libs/libxslt
"

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	:
}

src_install() {
	local doc_type my_lang

	for doc_type in help guide; do
		for my_lang in C ${L10N}; do
			case $my_lang in
				# Both help and guides translated
				C|de|it|pt) ;;
				ja) # Only guides translated
					if [[ ${doc_type} = "help" ]] ; then
						elog "Help documentation hasn't been translated for $my_lang"
						elog "Will do English instead."
						continue
					fi
					;;
				*)
					die "Invalid locale: $my_lang"
					;;
			esac

			emake -C "${doc_type}/${my_lang}" DESTDIR="${D}" install
		done
	done

	einstalldocs
}

pkg_postinst() {
	optfeature "generating PDF files" dev-java/fop
	optfeature "viewing the docs" gnome-extra/yelp
}
