# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Automatically color Python's uncaught exception tracebacks"
HOMEPAGE="https://github.com/staticshock/colored-traceback.py"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~riscv x86"

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]"
