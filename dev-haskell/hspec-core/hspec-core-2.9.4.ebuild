# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.7.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour" # Disable test-suite: circular depends
inherit haskell-cabal
RESTRICT=test # disabled at build time

DESCRIPTION="A Testing Framework for Haskell"
HOMEPAGE="https://hspec.github.io/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND=">=dev-haskell/ansi-terminal-0.6.2:=[profile?]
	dev-haskell/call-stack:=[profile?]
	>=dev-haskell/clock-0.7.1:=[profile?]
	>=dev-haskell/hspec-expectations-0.8.2:=[profile?] <dev-haskell/hspec-expectations-0.8.3:=[profile?]
	>=dev-haskell/hunit-1.6:=[profile?] <dev-haskell/hunit-1.7:=[profile?]
	>=dev-haskell/quickcheck-2.13.1:2=[profile?]
	>=dev-haskell/quickcheck-io-0.2.0:=[profile?]
	dev-haskell/random:=[profile?]
	dev-haskell/setenv:=[profile?]
	>=dev-haskell/stm-2.2:=[profile?]
	dev-haskell/tf-random:=[profile?]
	>=dev-lang/ghc-8.4.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
"
#	test? ( dev-haskell/base-orphans
#		~dev-haskell/hspec-meta-2.9.3
#		>=dev-haskell/quickcheck-2.14
#		>=dev-haskell/silently-1.2.4
#		dev-haskell/temporary )
