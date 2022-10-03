# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_COMPAT=6.0

inherit edo multiprocessing

DESCRIPTION="SMT-based program verifier"
HOMEPAGE="https://github.com/boogie-org/boogie/"
SRC_URI="
	https://github.com/boogie-org/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"
S="${S}"/Source

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="virtual/dotnet-sdk:${DOTNET_COMPAT}"
BDEPEND="${RDEPEND}"

# Generated by dotnet.
QA_PREBUILT="/usr/share/boogie/BoogieDriver"

src_prepare() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1
	export NUGET_PACKAGES="${S}"/nuget_packages
	export DOTNET_OUTPUT="${WORKDIR}"/${P}_net${DOTNET_COMPAT}_Release/${PN}

	default
}

src_configure() {
	edob dotnet restore
}

src_compile() {
	local myopts=(
		--configuration Release
		--no-restore
		--no-self-contained
		--nologo
		--output "${DOTNET_OUTPUT}"
		-consoleLoggerParameters:ErrorsOnly
		-maxCpuCount:$(makeopts_jobs)
	)
	edob dotnet build ${myopts[@]}
}

src_install() {
	mkdir -p "${ED}"/usr/share/ || die
	cp -r "${DOTNET_OUTPUT}" "${ED}"/usr/share/ || die
	dosym -r /usr/share/${PN}/BoogieDriver /usr/bin/boogie
}
