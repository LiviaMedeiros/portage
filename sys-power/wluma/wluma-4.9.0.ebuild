# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.5

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	anyhow@1.0.96
	ash@0.38.0+1.3.281
	autocfg@1.4.0
	backtrace@0.3.74
	bindgen@0.65.1
	bitflags@1.3.2
	bitflags@2.8.0
	bumpalo@3.17.0
	byteorder@1.5.0
	cc@1.2.15
	cexpr@0.6.0
	cfg-if@1.0.0
	chrono@0.4.40
	clang-sys@1.8.1
	colorchoice@1.0.3
	core-foundation-sys@0.8.7
	core-foundation@0.10.0
	core-graphics-types@0.2.0
	core-graphics@0.24.0
	dbus@0.9.7
	ddc-hi@0.4.1
	ddc-i2c@0.2.2
	ddc-macos@0.2.2
	ddc-winapi@0.2.2
	ddc@0.2.2
	downcast-rs@1.2.1
	downcast@0.11.0
	drm-fourcc@2.2.0
	dtoa@0.4.8
	edid@0.3.0
	either@1.14.0
	env_filter@0.1.3
	env_logger@0.11.6
	equivalent@1.0.2
	errno@0.3.10
	foreign-types-macros@0.2.3
	foreign-types-shared@0.3.1
	foreign-types@0.5.0
	fragile@2.0.0
	futures-core@0.3.31
	gimli@0.31.1
	glob@0.3.2
	hashbrown@0.15.2
	home@0.5.11
	humantime@2.1.0
	i2c-linux-sys@0.2.1
	i2c-linux@0.1.2
	i2c@0.1.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	indexmap@2.7.1
	inotify-sys@0.1.5
	inotify@0.11.0
	io-kit-sys@0.4.1
	is_terminal_polyfill@1.70.1
	itertools@0.14.0
	itoa@1.0.14
	js-sys@0.3.77
	lazy_static@1.5.0
	lazycell@1.3.0
	libc@0.2.170
	libdbus-sys@0.2.5
	libloading@0.8.6
	libudev-sys@0.1.4
	linked-hash-map@0.5.6
	linux-raw-sys@0.4.15
	log@0.4.26
	mach2@0.4.2
	mccs-caps@0.1.3
	mccs-db@0.1.3
	mccs@0.1.3
	memchr@1.0.2
	memchr@2.7.4
	minimal-lexical@0.2.1
	miniz_oxide@0.8.5
	mio@1.0.3
	mockall@0.13.1
	mockall_derive@0.13.1
	nom@3.2.1
	nom@7.1.3
	num-traits@0.2.19
	nvapi-sys@0.1.3
	nvapi@0.1.4
	object@0.36.7
	once_cell@1.20.3
	peeking_take_while@0.1.2
	pin-project-lite@0.2.16
	pkg-config@0.3.31
	predicates-core@1.0.9
	predicates-tree@1.0.12
	predicates@3.1.3
	prettyplease@0.2.29
	proc-macro2@1.0.93
	quick-xml@0.37.2
	quote@1.0.38
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	resize-slice@0.1.3
	rustc-demangle@0.1.24
	rustc-hash@1.1.0
	rustix@0.38.44
	rustversion@1.0.19
	ryu@1.0.19
	serde@1.0.218
	serde_derive@1.0.218
	serde_spanned@0.6.8
	serde_yaml@0.7.5
	serde_yaml@0.9.34+deprecated
	shlex@1.3.0
	smallvec@1.14.0
	socket2@0.5.8
	syn@2.0.98
	termtree@0.5.1
	thiserror-impl@1.0.69
	thiserror@1.0.69
	tokio@1.43.0
	toml@0.8.20
	toml_datetime@0.6.8
	toml_edit@0.22.24
	udev@0.2.0
	unicode-ident@1.0.17
	uninitialized@0.0.2
	unsafe-libyaml@0.2.11
	utf8parse@0.2.2
	v4l-sys@0.3.0
	v4l@0.14.0
	void@1.0.2
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	wayland-backend@0.3.8
	wayland-client@0.31.8
	wayland-protocols-wlr@0.3.6
	wayland-protocols@0.32.6
	wayland-scanner@0.31.6
	wayland-sys@0.31.6
	which@4.4.2
	widestring@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-link@0.1.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.3
	xdg@2.5.2
	yaml-rust@0.4.5
"

inherit udev cargo systemd

DESCRIPTION="Automatic brightness adjustment based on screen contents and ALS"
HOMEPAGE="https://github.com/maximbaz/wluma"
SRC_URI="
	https://github.com/maximbaz/wluma/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="ISC"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD ISC MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/libv4l:=
	media-libs/vulkan-loader:=
"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="/usr/bin/${PN}"

DOCS=(
	README.md
)

src_install() {
	cargo_src_install
	udev_dorules 90-wluma-backlight.rules

	insinto /etc/xdg/autostart
	doins "${FILESDIR}"/wluma.desktop
	systemd_douserunit "${PN}.service"

	insinto /usr/share/${P}
	doins config.toml

	dodoc "${DOCS[@]}"
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
