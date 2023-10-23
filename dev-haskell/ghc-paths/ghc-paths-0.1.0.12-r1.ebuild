# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.6.2.9999

# haddock feature is explicitely disabled, as this library can be used as haddock depend
CABAL_FEATURES="lib profile"
inherit haskell-cabal

DESCRIPTION="Knowledge of GHC's installation directories"
HOMEPAGE="https://hackage.haskell.org/package/ghc-paths"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND=">=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6 <dev-haskell/cabal-3.7
"

# https://github.com/simonmar/ghc-paths/pull/26
CABAL_CHDEPS=(
	'Cabal >= 1.6 && <3.1' 'Cabal >= 1.6 && <3.7'
)

src_prepare() {
	haskell-cabal_src_prepare
	# ghc-patch it has awfully unportable (across cabal versions) ghc detection code
	# but in gentoo we install it to fixed patch, so remove Setup.hs detection code
	cabal-mksetup

	# and use gentoo's hardcoded one:
	# a few things we need to replace, and example values
	# GHC_PATHS_LIBDIR /usr/lib64/ghc-6.12.0.20091010
	# GHC_PATHS_DOCDIR /usr/share/doc/ghc-6.12.0.20091010/html
	# GHC_PATHS_GHC_PKG /usr/bin/ghc-pkg
	# GHC_PATHS_GHC /usr/bin/ghc (be careful: GHC_PATHS_GHC is a substring of GHC_PATHS_GHC_PKG)

	cat >"${S}/GHC/Paths.hs" <<-EOF
	module GHC.Paths ( ghc, ghc_pkg, libdir, docdir ) where

	libdir, docdir, ghc, ghc_pkg :: FilePath

	libdir  = "$(ghc-libdir)"
	docdir  = "/usr/share/doc/ghc-$(ghc-version)/html"

	ghc     = "$(ghc-getghc)"
	ghc_pkg = "$(ghc-getghcpkg)"
	EOF
}
