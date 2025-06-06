# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Google's i18n address metadata repository"
HOMEPAGE="
	https://github.com/mirumee/google-i18n-address/
	https://pypi.org/project/google-i18n-address/
"
# Using the github release, as it contains the tests (unlike the pypi artifact).
SRC_URI="
	https://github.com/mirumee/google-i18n-address/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~x86"

RDEPEND="
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
