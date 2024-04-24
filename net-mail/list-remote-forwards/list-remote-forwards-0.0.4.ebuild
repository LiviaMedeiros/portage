# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CABAL_FEATURES="test-suite"
inherit haskell-cabal

DESCRIPTION="List all remote forwards for mail accounts stored in a database"
HOMEPAGE="https://michael.orlitzky.com/code/list-remote-forwards.xhtml"
SRC_URI="https://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

# dev-haskell/dns and dev-haskell/resolv conflict
# https://github.com/sol/doctest/issues/119
RESTRICT=test

RDEPEND=">=dev-haskell/cmdargs-0.10
	>=dev-haskell/configurator-0.2
	>=dev-haskell/dns-1.4
	>=dev-haskell/hdbc-2.4
	>=dev-haskell/hdbc-postgresql-2.3
	>=dev-haskell/hdbc-sqlite3-2.3
	>=dev-haskell/missingh-1.2
	>=dev-haskell/tasty-0.8
	>=dev-haskell/tasty-hunit-0.8
	>=dev-haskell/tasty-quickcheck-0.8
	>=dev-lang/ghc-9.0.0
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.0.0
	test? ( >=dev-haskell/doctest-0.9
		>=dev-haskell/filemanip-0.3.6 )
"

src_install() {
	haskell-cabal_src_install
	doman "${S}/doc/man1/${PN}.1"
}
