# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.2

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

MY_PN="BNFC"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A compiler front-end generator"
HOMEPAGE="http://bnfc.digitalgrammars.com/"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT=test # Ambiguous module name ‘Data.Time’: it was found in multiple packages: pulseaudio-0.0.2.1 time-1.8.0.2

RDEPEND="dev-haskell/mtl:=[profile?]
	dev-haskell/semigroups:=[profile?]
	>=dev-lang/ghc-7.6.1:=
"
DEPEND="${RDEPEND}
	dev-haskell/alex
	>=dev-haskell/cabal-1.16.0
	dev-haskell/happy
	test? ( >=dev-haskell/doctest-0.8
		dev-haskell/hspec
		dev-haskell/hunit
		>=dev-haskell/quickcheck-2.5
		dev-haskell/temporary )
"

S="${WORKDIR}/${MY_P}"
