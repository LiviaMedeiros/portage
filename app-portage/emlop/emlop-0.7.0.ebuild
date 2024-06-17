# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.2

EAPI=8

CRATES="
	adler@1.0.2
	aho-corasick@1.1.2
	anstream@0.6.13
	anstyle-parse@0.2.3
	anstyle-query@1.0.2
	anstyle-wincon@3.0.2
	anstyle@1.0.6
	anyhow@1.0.80
	assert_cmd@2.0.13
	atoi@2.0.0
	autocfg@1.1.0
	bstr@1.9.1
	cfg-if@1.0.0
	clap@4.4.18
	clap_builder@4.4.18
	clap_complete@4.4.10
	clap_derive@4.4.7
	clap_lex@0.6.0
	colorchoice@1.0.0
	crc32fast@1.4.0
	crossbeam-channel@0.5.12
	crossbeam-utils@0.8.19
	deranged@0.3.11
	difflib@0.4.0
	doc-comment@0.3.3
	env_filter@0.1.0
	env_logger@0.11.2
	equivalent@1.0.1
	emlop@0.7.0
	flate2@1.0.28
	hashbrown@0.14.3
	heck@0.4.1
	indexmap@2.2.5
	itoa@1.0.10
	libc@0.2.153
	log@0.4.21
	memchr@2.7.1
	miniz_oxide@0.7.2
	num-conv@0.1.0
	num-traits@0.2.18
	num_threads@0.1.7
	powerfmt@0.2.0
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@3.1.0
	proc-macro2@1.0.78
	quote@1.0.35
	regex-automata@0.4.6
	regex-syntax@0.8.2
	regex@1.10.3
	rev_lines@0.3.0
	ryu@1.0.17
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	serde_spanned@0.6.5
	strsim@0.10.0
	syn@2.0.52
	termtree@0.4.1
	thiserror-impl@1.0.57
	thiserror@1.0.57
	time-core@0.1.2
	time-macros@0.2.17
	time@0.3.34
	toml@0.8.10
	toml_datetime@0.6.5
	toml_edit@0.22.6
	unicode-ident@1.0.12
	utf8parse@0.2.1
	wait-timeout@0.2.0
	windows-sys@0.52.0
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.52.4
	winnow@0.6.5
"

inherit cargo shell-completion

DESCRIPTION="A fast, accurate, ergonomic emerge.log parser"
HOMEPAGE="https://github.com/vincentdephily/emlop"
SRC_URI="
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	   MIT Unicode-DFS-2016
	   || ( Apache-2.0 Boost-1.0 )
"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=virtual/rust-1.71.0"

# rust does not use *FLAGS from make.conf, silence portage warning
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	cargo_src_install
	dodoc README.md CHANGELOG.md emlop.toml
	# bash
	"$(cargo_target_dir)"/emlop complete bash > emlop || die
	dobashcomp emlop
	# zsh
	"$(cargo_target_dir)"/emlop complete zsh > _emlop || die
	dozshcomp _emlop
	# fish
	"$(cargo_target_dir)"/emlop complete fish > emlop.fish || die
	dofishcomp emlop.fish
}
