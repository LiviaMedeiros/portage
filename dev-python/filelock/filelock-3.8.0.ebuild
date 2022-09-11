# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_P=py-filelock-${PV}
DESCRIPTION="A platform independent file lock for Python"
HOMEPAGE="
	https://github.com/tox-dev/py-filelock/
	https://pypi.org/project/filelock/
"
SRC_URI="
	https://github.com/tox-dev/py-filelock/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

BDEPEND="
	>=dev-python/setuptools_scm-7.0.5[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
