# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="pytest plugin that allows you to add environment variables"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-env/
	https://pypi.org/project/pytest-env/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ~ppc ~ppc64 x86"

RDEPEND="
	>=dev-python/pytest-7.4.2[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/hatch-vcs-0.3[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# upstream lower bounds are meaningless
	sed -i -e 's:>=[0-9.]*::' pyproject.toml || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
