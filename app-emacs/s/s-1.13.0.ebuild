# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="The long lost Emacs string manipulation library"
HOMEPAGE="https://github.com/magnars/s.el"
SRC_URI="https://github.com/magnars/s.el/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/s.el-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc64 ~riscv ~sparc x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	sh run-tests.sh || die
}
