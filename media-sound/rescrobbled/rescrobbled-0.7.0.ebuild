# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.6

EAPI=8

CRATES="
	adler-1.0.2
	anyhow-1.0.58
	attohttpc-0.24.0
	autocfg-1.1.0
	bitflags-1.3.2
	bytes-1.2.0
	cc-1.0.73
	cfg-if-1.0.0
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	crc32fast-1.3.2
	darling-0.13.4
	darling_core-0.13.4
	darling_macro-0.13.4
	dbus-0.9.6
	derive_is_enum_variant-0.1.1
	dirs-4.0.0
	dirs-sys-0.3.7
	enum-kinds-0.5.1
	fastrand-1.7.0
	flate2-1.0.24
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.1
	from_variants-1.0.0
	from_variants_impl-1.0.0
	getrandom-0.2.7
	heck-0.3.3
	http-0.2.8
	ident_case-1.0.1
	idna-0.2.3
	instant-0.1.12
	itoa-1.0.2
	lazy_static-1.4.0
	libc-0.2.126
	libdbus-sys-0.2.2
	listenbrainz-0.5.0
	log-0.4.17
	matches-0.1.9
	md5-0.7.0
	miniz_oxide-0.5.3
	mpris-2.0.0
	native-tls-0.2.10
	once_cell-1.13.0
	openssl-0.10.41
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-sys-0.9.75
	percent-encoding-2.1.0
	pkg-config-0.3.25
	proc-macro2-1.0.40
	quote-0.3.15
	quote-1.0.20
	redox_syscall-0.2.13
	redox_users-0.4.3
	remove_dir_all-0.5.3
	rpassword-6.0.1
	rustfm-scrobble-proxy-1.1.3
	ryu-1.0.10
	schannel-0.1.20
	security-framework-2.6.1
	security-framework-sys-2.6.1
	serde-1.0.147
	serde_derive-1.0.147
	serde_json-1.0.87
	serde_urlencoded-0.7.1
	strsim-0.10.0
	syn-0.11.11
	syn-1.0.98
	synom-0.11.3
	tempfile-3.3.0
	thiserror-1.0.37
	thiserror-impl-1.0.37
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	toml-0.5.9
	unicode-bidi-0.3.8
	unicode-ident-1.0.2
	unicode-normalization-0.1.21
	unicode-segmentation-1.9.0
	unicode-xid-0.0.4
	url-2.2.2
	vcpkg-0.2.15
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_i686_gnu-0.36.1
	windows_i686_msvc-0.36.1
	windows_x86_64_gnu-0.36.1
	windows_x86_64_msvc-0.36.1
	wrapped-vec-0.3.0
"

inherit cargo systemd

DESCRIPTION="MPRIS music scrobbler daemon"
HOMEPAGE="https://github.com/InputUsername/rescrobbled"
SRC_URI="https://github.com/InputUsername/rescrobbled/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-libs/openssl:=
	sys-apps/dbus"

# Requires extra crates.
RESTRICT="test"

QA_FLAGS_IGNORED="/usr/bin/rescrobbled"

src_install() {
	cargo_src_install
	einstalldocs

	systemd_dounit "${S}"/rescrobbled.service

	dodoc "${FILESDIR}"/config.toml
	docompress -x "/usr/share/doc/${PF}/config.toml"

	dodoc -r "${S}"/filter-script-examples
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Sample configuration file has been installed to "
		elog "  /usr/share/doc/rescrobbled-${PVR}/config.toml"
		elog ""
		elog "Use the sample, or launch rescrobbled to create a new empty one."
		elog ""
	fi
}
