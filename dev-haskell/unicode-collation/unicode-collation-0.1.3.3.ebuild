# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.7.3.0

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Haskell implementation of the Unicode Collation Algorithm"
HOMEPAGE="https://github.com/jgm/unicode-collation"

LICENSE="BSD-2"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="doctests executable"

RDEPEND="dev-haskell/th-lift-instances:=[profile?]
	>=dev-lang/ghc-8.4.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
	test? ( dev-haskell/tasty
		dev-haskell/tasty-hunit
		dev-haskell/tasty-quickcheck
		>=dev-haskell/unicode-transforms-0.3.7.1
		doctests? ( >=dev-haskell/doctest-0.8 ) )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag doctests doctests) \
		$(cabal_flag executable executable)
}
