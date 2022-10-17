# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.2

EAPI=8

CRATES="
	ahash-0.3.8
	ansi_term-0.12.1
	ariadne-0.1.5
	atty-0.2.14
	autocfg-1.1.0
	bincode-1.3.3
	bitflags-1.3.2
	cc-1.0.73
	cfg-if-1.0.0
	chumsky-0.8.0
	clap-4.0.8
	clap_derive-4.0.8
	clap_lex-0.3.0
	colored_json-2.1.0
	const-random-0.1.13
	const-random-macro-0.1.13
	crunchy-0.2.2
	dyn-clone-1.0.9
	either-1.7.0
	env_logger-0.9.1
	fastrand-1.8.0
	getrandom-0.2.7
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	indexmap-1.9.1
	instant-0.1.12
	itertools-0.10.3
	itoa-1.0.3
	lazy_static-1.4.0
	libc-0.2.131
	libmimalloc-sys-0.1.25
	log-0.4.17
	mimalloc-0.1.29
	once_cell-1.13.0
	os_str_bytes-6.3.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-1.0.43
	quote-1.0.21
	redox_syscall-0.2.16
	remove_dir_all-0.5.3
	ryu-1.0.11
	serde-1.0.143
	serde_derive-1.0.143
	serde_json-1.0.83
	strsim-0.10.0
	syn-1.0.99
	tempfile-3.3.0
	termcolor-1.1.3
	tiny-keccak-2.0.2
	unicode-ident-1.0.3
	version_check-0.9.4
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	yansi-0.5.1
"

inherit cargo

DESCRIPTION="Just another JSON query tool"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/01mf02/jaq"
SRC_URI="
	https://github.com/01mf02/jaq/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	$(cargo_crate_uris)
"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="MIT Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 EPL-2.0 MIT Unicode-DFS-2016 Unlicense"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/bin/jaq"

DOCS=(
	README.md
)

src_install() {
	pushd "${S}/jaq" >/dev/null || die
	cargo_src_install
	popd >/dev/null || die
	default
}
