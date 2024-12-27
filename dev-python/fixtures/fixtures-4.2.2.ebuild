# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pbr
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Fixtures, reusable state for writing clean tests and more"
HOMEPAGE="
	https://github.com/testing-cabal/fixtures/
	https://pypi.org/project/fixtures/
"

LICENSE="|| ( Apache-2.0 BSD )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/pbr-5.7.0[${PYTHON_USEDEP}]
	>=dev-python/testtools-2.5.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
