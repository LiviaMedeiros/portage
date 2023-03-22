# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=2.218
inherit perl-module

DESCRIPTION="Simple parsing of RFC2822 message format and headers"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~sparc-solaris ~x86-solaris"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Email-Date-Format
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
