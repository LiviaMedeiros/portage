# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.7.9999
#hackport: flags: +splitbase -buildtests

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

MY_PN="HDBC-postgresql"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PostgreSQL driver for HDBC"
HOMEPAGE="https://github.com/hdbc/hdbc-postgresql"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="2/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND=">=dev-db/postgresql-7:*
	dev-haskell/convertible:=[profile?]
	>=dev-haskell/hdbc-2.2.0:2=[profile?]
	dev-haskell/mtl:=[profile?]
	dev-haskell/old-locale:=[profile?]
	dev-haskell/old-time:=[profile?]
	dev-haskell/parsec:=[profile?]
	dev-haskell/utf8-string:=[profile?]
	>=dev-lang/ghc-8.4.3:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	cabal_chdeps \
		'Cabal >= 1.8 && < 3.3' 'Cabal >= 1.8'
}

src_configure() {
	haskell-cabal_src_configure \
		--flag=-buildtests \
		--flag=splitbase
}
