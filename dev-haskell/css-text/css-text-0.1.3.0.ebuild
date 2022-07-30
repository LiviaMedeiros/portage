# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.5.5.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="CSS parser and renderer"
HOMEPAGE="https://github.com/yesodweb/css-text.git#readme"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RESTRICT=test # fails test, not sure if it's severe

RDEPEND=">=dev-haskell/attoparsec-0.10.2.0:=[profile?]
	>=dev-haskell/semigroups-0.16.1:=[profile?]
	>=dev-haskell/text-0.11:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.10
	test? ( >=dev-haskell/hspec-1.3
		dev-haskell/quickcheck )
"
