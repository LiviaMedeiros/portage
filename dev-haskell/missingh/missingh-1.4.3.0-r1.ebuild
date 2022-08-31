# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.4.9999
#hackport: flags: +network--ge-3-0-0

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

MY_PN="MissingH"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Large utility library"
HOMEPAGE="https://hackage.haskell.org/package/MissingH"
SRC_URI="https://hackage.haskell.org/package/${MY_P}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux"

RESTRICT=test # tests are present for removed modules

RDEPEND=">=dev-haskell/hslogger-1.3.0.0:=[profile?] <dev-haskell/hslogger-1.4:=[profile?]
	>=dev-haskell/mtl-1.1.1.0:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/old-locale-1.0:=[profile?] <dev-haskell/old-locale-1.1:=[profile?]
	>=dev-haskell/old-time-1.1:=[profile?] <dev-haskell/old-time-1.2:=[profile?]
	>=dev-haskell/parsec-3.1:=[profile?] <dev-haskell/parsec-3.2:=[profile?]
	dev-haskell/random
	>=dev-haskell/regex-compat-0.95.1:=[profile?] <dev-haskell/regex-compat-0.96:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	>=dev-haskell/network-3.0:=[profile?] <dev-haskell/network-3.2:=[profile?]
	>=dev-haskell/network-bsd-2.8.1:=[profile?] <dev-haskell/network-bsd-2.9:=[profile?]
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.12
	test? ( >=dev-haskell/errorcall-eq-instance-0.3 <dev-haskell/errorcall-eq-instance-0.4
		>=dev-haskell/hunit-1.6 <dev-haskell/hunit-1.7 )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	cabal_chdeps \
		'base                >= 4.5.0.0 && < 4.15' 'base                >= 4.5.0.0' \
		'random              >= 1.0.1.1 && < 1.2' 'random'
}

src_configure() {
	haskell-cabal_src_configure \
		--flag=network--ge-3_0_0
}
