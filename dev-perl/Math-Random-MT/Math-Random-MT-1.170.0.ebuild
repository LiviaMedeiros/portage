# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=FANGLY
MODULE_VERSION=1.17
inherit perl-module

DESCRIPTION="The Mersenne Twister PRNG"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		dev-perl/Test-Number-Delta
	)
"

SRC_TEST=do
