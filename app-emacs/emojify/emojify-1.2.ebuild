# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Display emojis in Emacs, like :smile: or plain ASCII ones like :)"
HOMEPAGE="https://github.com/iqbalansari/emacs-emojify/"
SRC_URI="https://github.com/iqbalansari/emacs-${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  # Tests fail

RDEPEND="app-emacs/ht"
BDEPEND="${RDEPEND}"

DOCS=( CHANGELOG.org README.org screenshots )
PATCHES=( "${FILESDIR}"/${PN}-json-data.patch )
ELISP_REMOVE=".dir-locals.el"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed -i "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|g" ${PN}.el || die
}

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}
	doins -r data
}
