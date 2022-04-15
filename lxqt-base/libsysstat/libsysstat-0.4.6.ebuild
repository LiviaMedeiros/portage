# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt GUI for System Statistics"
HOMEPAGE="https://lxqt-project.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~riscv x86"
fi

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

BDEPEND=">=dev-util/lxqt-build-tools-0.10.0"
DEPEND=">=dev-qt/qtcore-5.15:5"
RDEPEND="${DEPEND}"
