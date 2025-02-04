# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	aead@0.5.2
	aes-gcm@0.10.3
	aes@0.8.4
	ahash@0.8.11
	aho-corasick@1.1.3
	aligned@0.4.2
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	anyhow@1.0.95
	arraydeque@0.5.1
	as-slice@0.2.1
	ascii-canvas@3.0.0
	ascii-canvas@4.0.0
	assert_cmd@2.0.16
	async-generic@1.1.2
	async-trait@0.1.83
	atomic-waker@1.1.2
	autocfg@1.4.0
	backtrace@0.3.74
	base16ct@0.2.0
	base64@0.21.7
	base64@0.22.1
	base64ct@1.6.0
	bindgen@0.68.1
	bit-set@0.5.3
	bit-set@0.8.0
	bit-vec@0.6.3
	bit-vec@0.8.0
	bitflags@2.6.0
	block-buffer@0.10.4
	block-padding@0.3.3
	blowfish@0.9.1
	botan-sys@0.11.0
	botan@0.11.0
	bstr@1.11.1
	buffered-reader@1.3.2
	bumpalo@3.16.0
	byteorder@1.5.0
	bytes@1.9.0
	bzip2-sys@0.1.11+1.0.8
	bzip2@0.5.0
	camellia@0.1.0
	capnp-futures@0.19.1
	capnp-rpc@0.19.5
	capnp@0.19.8
	capnpc@0.19.0
	cast5@0.11.1
	cc@1.2.6
	cexpr@0.6.0
	cfb-mode@0.8.2
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.39
	cipher@0.4.4
	clang-sys@1.8.1
	clap@4.5.23
	clap_builder@4.5.23
	clap_complete@4.5.40
	clap_derive@4.5.18
	clap_lex@0.7.4
	cmac@0.7.2
	colorchoice@1.0.3
	console@0.15.10
	const-oid@0.9.6
	core-foundation-sys@0.8.7
	core-foundation@0.9.4
	cpufeatures@0.2.16
	crc32fast@1.4.2
	crossbeam-channel@0.5.14
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.12
	crossbeam-utils@0.8.21
	crossbeam@0.8.4
	crunchy@0.2.2
	crypto-bigint@0.5.5
	crypto-common@0.1.6
	ctor@0.2.9
	ctr@0.9.2
	culpa-macros@1.0.2
	culpa@1.0.2
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.3
	cvt@0.1.2
	data-encoding@2.6.0
	dbl@0.3.2
	der@0.7.9
	deranged@0.3.11
	des@0.8.1
	descape@2.0.3
	deunicode@1.6.0
	difflib@0.4.0
	digest@0.10.7
	directories@5.0.1
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	dirs-sys@0.4.1
	dirs@5.0.1
	displaydoc@0.2.5
	doc-comment@0.3.3
	dsa@0.6.3
	dyn-clone@1.0.17
	eax@0.5.0
	ecb@0.1.2
	ecdsa@0.16.9
	ed25519-dalek@2.1.1
	ed25519@2.2.3
	either@1.13.0
	elliptic-curve@0.13.8
	embedded-io@0.6.1
	ena@0.14.3
	encode_unicode@1.0.0
	encoding_rs@0.8.35
	endian-type@0.1.2
	enum-as-inner@0.6.1
	env_filter@0.1.3
	env_logger@0.11.6
	equivalent@1.0.1
	errno@0.3.10
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fastrand@2.3.0
	fd-lock@4.0.2
	ff@0.13.0
	fiat-crypto@0.2.9
	filetime@0.2.25
	fixedbitset@0.4.2
	flate2@1.0.35
	float-cmp@0.10.0
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.1
	fs2@0.4.3
	fs_at@0.2.1
	fs_extra@1.3.0
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.3.31
	generator@0.7.5
	generic-array@0.14.7
	generic-array@1.1.1
	gethostname@0.5.0
	getopts@0.2.21
	getrandom@0.2.15
	ghash@0.5.1
	gimli@0.31.1
	glob@0.3.2
	globset@0.4.15
	globwalk@0.9.1
	group@0.13.0
	h2@0.4.7
	hashbrown@0.14.5
	hashbrown@0.15.2
	hashlink@0.9.1
	heck@0.5.0
	hermit-abi@0.3.9
	hickory-client@0.24.2
	hickory-proto@0.24.2
	hickory-resolver@0.24.2
	hkdf@0.12.4
	hmac@0.12.1
	home@0.5.9
	hostname@0.3.1
	html-escape@0.2.13
	http-body-util@0.1.2
	http-body@1.0.1
	http@1.2.0
	httparse@1.9.5
	humansize@2.1.3
	humantime@2.1.0
	hyper-rustls@0.27.5
	hyper-tls@0.6.0
	hyper-util@0.1.10
	hyper@1.5.2
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idea@0.5.1
	idna@1.0.3
	idna_adapter@1.2.0
	ignore@0.4.23
	indexmap@2.7.0
	indicatif@0.17.9
	inout@0.1.3
	ipconfig@0.3.2
	ipnet@2.10.1
	is_terminal_polyfill@1.70.1
	itertools@0.11.0
	itertools@0.13.0
	itoa@1.0.14
	js-sys@0.3.76
	keccak@0.1.5
	lalrpop-util@0.20.2
	lalrpop-util@0.22.0
	lalrpop@0.20.2
	lalrpop@0.22.0
	lazy_static@1.5.0
	lazycell@1.3.0
	libc@0.2.169
	libloading@0.8.6
	libm@0.2.11
	libredox@0.1.3
	libsqlite3-sys@0.30.1
	line-col@0.2.1
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.14
	litemap@0.7.4
	lock_api@0.4.12
	log@0.4.22
	loom@0.5.6
	lru-cache@0.1.2
	marked-yaml@0.7.2
	match_cfg@0.1.0
	matchers@0.1.0
	md-5@0.10.6
	memchr@2.7.4
	memsec@0.7.0
	mime@0.3.17
	minimal-lexical@0.2.1
	miniz_oxide@0.8.2
	mio@1.0.3
	native-tls@0.2.12
	nettle-sys@2.3.0
	nettle@7.4.0
	new_debug_unreachable@1.0.6
	nibble_vec@0.1.0
	nix@0.29.0
	nom@7.1.3
	normalize-line-endings@0.3.0
	normpath@1.3.0
	nu-ansi-term@0.46.0
	num-bigint-dig@0.8.4
	num-conv@0.1.0
	num-integer@0.1.46
	num-iter@0.1.45
	num-traits@0.2.19
	num_cpus@1.16.0
	number_prefix@0.4.0
	object@0.36.7
	once_cell@1.20.2
	opaque-debug@0.3.1
	openpgp-cert-d@0.3.3
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.104
	openssl@0.10.68
	option-ext@0.2.0
	overload@0.1.1
	p256@0.13.2
	p384@0.13.0
	p521@0.13.3
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	paste@1.0.15
	peeking_take_while@0.1.2
	pem-rfc7468@0.7.0
	percent-encoding@2.3.1
	pest@2.7.15
	pest_derive@2.7.15
	pest_generator@2.7.15
	pest_meta@2.7.15
	petgraph@0.6.5
	phf_shared@0.10.0
	pikchr@0.1.3
	pin-project-lite@0.2.15
	pin-utils@0.1.0
	pkcs1@0.7.5
	pkcs8@0.10.2
	pkg-config@0.3.31
	polyval@0.6.2
	portable-atomic@1.10.0
	powerfmt@0.2.0
	ppv-lite86@0.2.20
	precomputed-hash@0.1.1
	predicates-core@1.0.9
	predicates-tree@1.0.12
	predicates@3.1.3
	primeorder@0.13.6
	proc-macro2@1.0.92
	pulldown-cmark-escape@0.11.0
	pulldown-cmark@0.12.2
	quick-error@1.2.3
	quote@1.0.38
	radix_trie@0.2.1
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.8
	redox_users@0.4.6
	regex-automata@0.1.10
	regex-automata@0.4.9
	regex-syntax@0.6.29
	regex-syntax@0.8.5
	regex@1.11.1
	remove_dir_all@1.0.0
	reqwest@0.12.12
	resolv-conf@0.7.0
	rfc6979@0.4.0
	ring@0.17.8
	ripemd@0.1.3
	roadmap@0.7.0
	roff@0.2.2
	rpassword@7.3.1
	rsa@0.9.7
	rtoolbox@0.0.2
	rusqlite@0.32.1
	rustc-demangle@0.1.24
	rustc-hash@1.1.0
	rustc_version@0.4.1
	rustix@0.38.42
	rustls-pemfile@2.2.0
	rustls-pki-types@1.10.1
	rustls-webpki@0.102.8
	rustls@0.23.20
	rustversion@1.0.19
	ryu@1.0.18
	same-file@1.0.6
	schannel@0.1.27
	scoped-tls@1.0.1
	scopeguard@1.2.0
	sec1@0.7.3
	security-framework-sys@2.13.0
	security-framework@2.11.1
	semver@1.0.24
	sequoia-autocrypt@0.25.1
	sequoia-cert-store@0.6.2
	sequoia-directories@0.1.0
	sequoia-gpg-agent@0.5.0
	sequoia-ipc@0.35.1
	sequoia-keystore-backend@0.6.0
	sequoia-keystore-gpg-agent@0.4.1
	sequoia-keystore-softkeys@0.6.0
	sequoia-keystore@0.6.2
	sequoia-net@0.29.0
	sequoia-openpgp@1.22.0
	sequoia-policy-config@0.7.0
	sequoia-wot@0.13.2
	serde@1.0.217
	serde_derive@1.0.217
	serde_json@1.0.134
	serde_path_to_error@0.1.16
	serde_urlencoded@0.7.1
	sha1collisiondetection@0.3.4
	sha2@0.10.8
	sha3@0.10.8
	sharded-slab@0.1.7
	shell-words@1.1.0
	shlex@1.3.0
	signature@2.2.0
	siphasher@0.3.11
	slab@0.4.9
	slug@0.1.6
	smallvec@1.13.2
	smawk@0.3.2
	socket2@0.5.8
	spin@0.9.8
	spki@0.7.3
	stable_deref_trait@1.2.0
	state@0.6.0
	stfu8@0.2.7
	string_cache@0.8.7
	strsim@0.11.1
	subplot-build@0.12.0
	subplot@0.12.0
	subplotlib-derive@0.12.0
	subplotlib@0.12.0
	subtle@2.6.1
	syn@2.0.93
	sync_wrapper@1.0.2
	synstructure@0.13.1
	system-configuration-sys@0.6.0
	system-configuration@0.6.1
	tempfile@3.14.0
	tera@1.20.0
	term@0.7.0
	term@1.0.1
	termcolor@1.4.1
	terminal_size@0.4.1
	termtree@0.5.1
	textwrap@0.16.1
	thiserror-impl@1.0.69
	thiserror-impl@2.0.9
	thiserror@1.0.69
	thiserror@2.0.9
	thread_local@1.1.8
	time-core@0.1.2
	time-macros@0.2.19
	time@0.3.37
	tiny-keccak@2.0.2
	tinystr@0.7.6
	tinyvec@1.8.1
	tinyvec_macros@0.1.1
	tokio-macros@2.4.0
	tokio-native-tls@0.3.1
	tokio-rustls@0.26.1
	tokio-util@0.7.13
	tokio@1.42.0
	toml@0.5.11
	toml_datetime@0.6.8
	toml_edit@0.22.22
	tower-layer@0.3.3
	tower-service@0.3.3
	tower@0.5.2
	tracing-attributes@0.1.28
	tracing-core@0.1.33
	tracing-log@0.2.0
	tracing-subscriber@0.3.19
	tracing@0.1.41
	try-lock@0.2.5
	twofish@0.7.1
	typenum@1.17.0
	ucd-trie@0.1.7
	unic-char-property@0.9.0
	unic-char-range@0.9.0
	unic-common@0.9.0
	unic-segment@0.9.0
	unic-ucd-segment@0.9.0
	unic-ucd-version@0.9.0
	unicase@2.8.1
	unicode-ident@1.0.14
	unicode-linebreak@0.1.5
	unicode-width@0.1.14
	unicode-width@0.2.0
	unicode-xid@0.2.6
	universal-hash@0.5.1
	untrusted@0.9.0
	url@2.5.4
	utf16_iter@1.0.5
	utf8-width@0.1.7
	utf8_iter@1.0.4
	utf8parse@0.2.2
	valuable@0.1.0
	vcpkg@0.2.15
	version_check@0.9.5
	wait-timeout@0.2.0
	walkdir@2.5.0
	want@0.3.1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.99
	wasm-bindgen-futures@0.4.49
	wasm-bindgen-macro-support@0.2.99
	wasm-bindgen-macro@0.2.99
	wasm-bindgen-shared@0.2.99
	wasm-bindgen@0.2.99
	wasm-streams@0.4.2
	web-sys@0.3.76
	web-time@1.1.0
	widestring@1.1.0
	win-crypto-ng@0.5.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-registry@0.2.0
	windows-result@0.2.0
	windows-strings@0.1.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows@0.48.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	winnow@0.6.21
	winreg@0.50.0
	write16@1.0.0
	writeable@0.5.5
	x25519-dalek@2.0.1
	xxhash-rust@0.8.15
	yaml-rust2@0.9.0
	yoke-derive@0.7.5
	yoke@0.7.5
	z-base-32@0.1.4
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zeroize@1.8.1
	zeroize_derive@1.4.2
	zerovec-derive@0.10.3
	zerovec@0.10.4
"

LLVM_COMPAT=( {16..18} )

inherit cargo llvm-r1 shell-completion

DESCRIPTION="CLI of the Sequoia OpenPGP implementation"
HOMEPAGE="https://sequoia-pgp.org/ https://gitlab.com/sequoia-pgp/sequoia-sq"
SRC_URI="
	https://gitlab.com/sequoia-pgp/sequoia-sq/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="LGPL-2.1+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC LGPL-2+ MIT MIT-0 MPL-2.0
	Unicode-3.0
	|| ( GPL-2 GPL-3 LGPL-3 )
"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"

QA_FLAGS_IGNORED="usr/bin/sq"

COMMON_DEPEND="
	dev-db/sqlite:3
	dev-libs/gmp:=
	dev-libs/nettle:=
	dev-libs/openssl:=
"
DEPEND="
	${COMMON_DEPEND}
	dev-libs/capnproto
"
RDEPEND="
	${COMMON_DEPEND}
"
# Clang needed for bindgen
BDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}
	')
	virtual/pkgconfig
"

pkg_setup() {
	llvm-r1_pkg_setup
	rust_pkg_setup
}

src_compile() {
	# Set this here so that it doesn't change if we run tests
	# and cause a recompilation.
	asset_dir="${T}"/assets
	export ASSET_OUT_DIR="${asset_dir}"

	# Setting CARGO_TARGET_DIR is required to have the build system
	# create the bash and zsh completion files.
	export CARGO_TARGET_DIR="${S}/target"
	cargo_src_compile
}

src_install() {
	cargo_src_install

	doman "${asset_dir}"/man-pages/*

	local completion_dir="${asset_dir}"/shell-completions
	newbashcomp "${completion_dir}"/sq.bash sq
	dozshcomp "${completion_dir}"/_sq
	dofishcomp "${completion_dir}"/sq.fish
}
