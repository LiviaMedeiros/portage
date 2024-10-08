# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RGARCIA
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Retrieve names of code references"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Exporter
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files "t/pod.t"
	perl-module_src_test
}
