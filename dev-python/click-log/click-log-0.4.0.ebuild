# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Logging integration for Click"
HOMEPAGE="
	https://github.com/click-contrib/click-log/
	https://pypi.org/project/click-log/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
"

DOCS=( README.rst )

distutils_enable_tests pytest
