# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Wrapper around re or regex that adds additional back references"
HOMEPAGE="
	https://github.com/facelessuser/backrefs/
	https://pypi.org/project/backrefs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_tests pytest
