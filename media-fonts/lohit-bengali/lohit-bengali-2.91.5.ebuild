# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR="/usr/share/fonts/indic/${PN}"
FONT_SUFFIX="ttf"
inherit font

DESCRIPTION="The Lohit Bengali font"
HOMEPAGE="https://pagure.io/lohit"
SRC_URI="https://releases.pagure.org/lohit/${PN}-${FONT_SUFFIX}-${PV}.tar.gz"
S=${WORKDIR}/${PN}-${FONT_SUFFIX}-${PV}

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-macos"
IUSE=""

RESTRICT="test binchecks"

RDEPEND="!<media-fonts/lohit-fonts-2.20150220"

FONT_CONF=( "66-${PN}.conf" )
