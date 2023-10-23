# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.8.4.0.9999
#hackport: flags: +base4,-devel,+force-o2,-doctest

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Pure Haskell Tagged DFA Backend for \"Text.Regex\" (regex-base)"
HOMEPAGE="https://wiki.haskell.org/Regular_expressions"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}/${P}-disable-doctests.patch"
)

RDEPEND=">=dev-haskell/parsec-3.1:=[profile?] <dev-haskell/parsec-3.2:=[profile?]
	>=dev-haskell/regex-base-0.94:=[profile?] <dev-haskell/regex-base-0.95:=[profile?]
	>=dev-haskell/text-1.2.3:=[profile?] <dev-haskell/text-2.1:=[profile?]
	>=dev-lang/ghc-8.8.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.0.0.0
	test? ( >=dev-haskell/utf8-string-1.0.1 <dev-haskell/utf8-string-1.1
	)
"

src_configure() {
	haskell-cabal_src_configure \
		--flag=base4 \
		--flag=-devel \
		--flag=force-o2
}
