# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.3

EAPI=8

CRATES="
	ahash@0.8.7
	aho-corasick@1.1.2
	atty@0.2.14
	autocfg@1.3.0
	base64@0.22.0
	bitflags@1.3.2
	bumpalo@3.14.0
	cc@1.0.79
	cfg-if@1.0.0
	chrono@0.4.38
	clap@4.0.22
	clap_derive@4.0.21
	clap_lex@0.3.2
	codesnake@0.2.0
	console_log@1.0.0
	dyn-clone@1.0.11
	env_logger@0.10.2
	equivalent@1.0.0
	fastrand@1.9.0
	getrandom@0.2.10
	hashbrown@0.14.2
	heck@0.4.1
	hermit-abi@0.1.19
	hifijson@0.2.2
	indexmap@2.1.0
	instant@0.1.12
	itoa@1.0.9
	js-sys@0.3.69
	libc@0.2.147
	libm@0.2.8
	libmimalloc-sys@0.1.39
	log@0.4.20
	memchr@2.6.4
	memmap2@0.9.0
	mimalloc@0.1.43
	num-traits@0.2.19
	once_cell@1.18.0
	os_str_bytes@6.4.1
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.69
	quote@1.0.29
	redox_syscall@0.2.16
	regex-automata@0.3.7
	regex-syntax@0.7.5
	regex@1.9.4
	remove_dir_all@0.5.3
	ryu@1.0.14
	serde@1.0.190
	serde_derive@1.0.190
	serde_json@1.0.108
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.38
	tempfile@3.3.0
	termcolor@1.2.0
	unicode-ident@1.0.10
	unicode-width@0.1.13
	urlencoding@2.1.3
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	web-sys@0.3.69
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	yansi@1.0.1
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
"

inherit cargo

DESCRIPTION="Just another JSON query tool"
HOMEPAGE="https://github.com/01mf02/jaq"
SRC_URI="
	https://github.com/01mf02/jaq/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	BSD MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=virtual/rust-1.64
"

QA_FLAGS_IGNORED="usr/bin/jaq"
QA_PRESTRIPPED="usr/bin/jaq"

DOCS=(
	README.md
	examples/
)

src_install() {
	pushd "${S}/jaq" >/dev/null || die
	cargo_src_install
	popd >/dev/null || die

	default
}
