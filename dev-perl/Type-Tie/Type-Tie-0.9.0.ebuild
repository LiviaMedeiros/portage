# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.009
inherit perl-module

DESCRIPTION="Tie a variable to a type constraint"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ~ia64 ppc ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		dev-perl/Hash-FieldHash
	)
	>=dev-perl/Exporter-Tiny-0.26.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.960.0
	)
"
