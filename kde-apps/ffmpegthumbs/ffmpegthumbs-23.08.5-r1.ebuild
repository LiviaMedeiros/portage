# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="FFmpeg based thumbnail generator for video files"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	media-video/ffmpeg:0=
"
RDEPEND="${DEPEND}
	${CATEGORY}/${PN}-common
"
BDEPEND="
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	virtual/pkgconfig
"

# Shipped by kde-apps/ffmpegthumbs-common package for shared use w/ SLOT 5
ECM_REMOVE_FROM_INSTALL=(
	/usr/share/config.kcfg/ffmpegthumbnailersettings5.kcfg
	/usr/share/metainfo/org.kde.ffmpegthumbs.metainfo.xml
)
