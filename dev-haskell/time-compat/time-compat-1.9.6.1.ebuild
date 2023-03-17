# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.7.1.1.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
CABAL_HACKAGE_REVISION="3"
inherit haskell-cabal

DESCRIPTION="Compatibility package for time"
HOMEPAGE="https://github.com/haskellari/time-compat"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz
	https://hackage.haskell.org/package/${P}/revision/${CABAL_HACKAGE_REVISION}.cabal -> ${PF}.cabal"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND=">=dev-haskell/base-orphans-0.8.4:=[profile?] <dev-haskell/base-orphans-0.9:=[profile?]
	>=dev-haskell/hashable-1.3.2.0:=[profile?] <dev-haskell/hashable-1.5:=[profile?]
	>=dev-lang/ghc-8.4.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
	test? ( >=dev-haskell/base-compat-0.10.5 <dev-haskell/base-compat-0.13
		>=dev-haskell/quickcheck-2.13 <dev-haskell/quickcheck-2.15
		>=dev-haskell/tagged-0.8.6 <dev-haskell/tagged-0.9
		>=dev-haskell/tasty-1.2.1 <dev-haskell/tasty-1.5
		>=dev-haskell/tasty-hunit-0.10 <dev-haskell/tasty-hunit-0.11
		>=dev-haskell/tasty-quickcheck-0.10 <dev-haskell/tasty-quickcheck-0.11
		|| ( ( >=dev-haskell/hunit-1.3.1 <dev-haskell/hunit-1.3.2 )
			( >=dev-haskell/hunit-1.6.0.0 <dev-haskell/hunit-1.7 ) ) )
"
BDEPEND="app-text/dos2unix"

PATCHES=( "${FILESDIR}/fix-resolution-test.patch" )

src_prepare() {
	# pull revised cabal from upstream
	cp "${DISTDIR}/${PF}.cabal" "${S}/${PN}.cabal" || die

	# Convert to unix line endings
	dos2unix "${S}/${PN}.cabal" || die

	# Apply patches *after* pulling the revised cabal
	default
}
