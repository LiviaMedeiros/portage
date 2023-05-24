# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="python implementation of SPAKE2 password-authenticated key exchange algorithm"
HOMEPAGE="https://pypi.org/project/spake2/"
SRC_URI="https://github.com/warner/python-${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/python-${P}"

RDEPEND="
	dev-python/hkdf[${PYTHON_USEDEP}]"
