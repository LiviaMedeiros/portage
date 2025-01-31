# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.4

EAPI=8

CRATES="
"

declare -A GIT_CRATES=(
	[alacritty_terminal]='https://github.com/alacritty/alacritty;91d034ff8b53867143c005acfaa14609147c9a2c;alacritty-%commit%/alacritty_terminal'
	[async-pipe]='https://github.com/zed-industries/async-pipe-rs;82d00a04211cf4e1236029aa03e6b6ce2a74c553;async-pipe-rs-%commit%'
	[async-stripe]='https://github.com/zed-industries/async-stripe;3672dd4efb7181aa597bf580bf5a2f5d23db6735;async-stripe-%commit%'
	[blade-graphics]='https://github.com/kvark/blade;e142a3a5e678eb6a13e642ad8401b1f3aa38e969;blade-%commit%/blade-graphics'
	[blade-macros]='https://github.com/kvark/blade;e142a3a5e678eb6a13e642ad8401b1f3aa38e969;blade-%commit%/blade-macros'
	[blade-util]='https://github.com/kvark/blade;e142a3a5e678eb6a13e642ad8401b1f3aa38e969;blade-%commit%/blade-util'
	[cosmic-text]='https://github.com/pop-os/cosmic-text;542b20ca4376a3b5de5fa629db1a4ace44e18e0c;cosmic-text-%commit%'
	[font-kit]='https://github.com/zed-industries/font-kit;40391b7c0041d8a8572af2afa3de32ae088f0120;font-kit-%commit%'
	[lsp-types]='https://github.com/zed-industries/lsp-types;72357d6f6d212bdffba3b5ef4b31d8ca856058e7;lsp-types-%commit%'
	[nvim-rs]='https://github.com/KillTheMule/nvim-rs;69500bae73b8b3f02a05b7bee621a0d0e633da6c;nvim-rs-%commit%'
	[pet-conda]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-conda'
	[pet-core]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-core'
	[pet-env-var-path]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-env-var-path'
	[pet-fs]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-fs'
	[pet-global-virtualenvs]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-global-virtualenvs'
	[pet-homebrew]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-homebrew'
	[pet-jsonrpc]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-jsonrpc'
	[pet-linux-global-python]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-linux-global-python'
	[pet-mac-commandlinetools]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-mac-commandlinetools'
	[pet-mac-python-org]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-mac-python-org'
	[pet-mac-xcode]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-mac-xcode'
	[pet-pipenv]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-pipenv'
	[pet-poetry]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-poetry'
	[pet-pyenv]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-pyenv'
	[pet-python-utils]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-python-utils'
	[pet-reporter]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-reporter'
	[pet-telemetry]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-telemetry'
	[pet-venv]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-venv'
	[pet-virtualenv]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-virtualenv'
	[pet-virtualenvwrapper]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-virtualenvwrapper'
	[pet-windows-registry]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-windows-registry'
	[pet-windows-store]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet-windows-store'
	[pet]='https://github.com/microsoft/python-environment-tools;ffcbf3f28c46633abd5448a52b1f396c322e0d6c;python-environment-tools-%commit%/crates/pet'
	[reqwest]='https://github.com/zed-industries/reqwest;fd110f6998da16bbca97b6dddda9be7827c50e29;reqwest-%commit%'
	[tree-sitter-gomod]='https://github.com/zed-industries/tree-sitter-go-mod;a9aea5e358cde4d0f8ff20b7bc4fa311e359c7ca;tree-sitter-go-mod-%commit%'
	[tree-sitter-gowork]='https://github.com/zed-industries/tree-sitter-go-work;acb0617bf7f4fda02c6217676cc64acb89536dc7;tree-sitter-go-work-%commit%'
	[tree-sitter-heex]='https://github.com/zed-industries/tree-sitter-heex;1dd45142fbb05562e35b2040c6129c9bca346592;tree-sitter-heex-%commit%'
	[tree-sitter-md]='https://github.com/tree-sitter-grammars/tree-sitter-markdown;9a23c1a96c0513d8fc6520972beedd419a973539;tree-sitter-markdown-%commit%'
	[tree-sitter-yaml]='https://github.com/zed-industries/tree-sitter-yaml;baff0b51c64ef6a1fb1f8390f3ad6015b83ec13a;tree-sitter-yaml-%commit%'
	[xim-ctext]='https://github.com/XDeme1/xim-rs;d50d461764c2213655cd9cf65a0ea94c70d3c4fd;xim-rs-%commit%/xim-ctext'
	[xim-parser]='https://github.com/XDeme1/xim-rs;d50d461764c2213655cd9cf65a0ea94c70d3c4fd;xim-rs-%commit%/xim-parser'
	[xim]='https://github.com/XDeme1/xim-rs;d50d461764c2213655cd9cf65a0ea94c70d3c4fd;xim-rs-%commit%'
	[xkbcommon]='https://github.com/ConradIrwin/xkbcommon-rs;fcbb4612185cc129ceeff51d22f7fb51810a03b2;xkbcommon-rs-%commit%'
)

LLVM_COMPAT=( {18..19} )
RUST_MIN_VER="1.81.0"
RUST_NEEDS_LLVM=1

inherit cargo check-reqs desktop flag-o-matic llvm-r1 toolchain-funcs xdg

DESCRIPTION="The fast, collaborative code editor"
HOMEPAGE="https://zed.dev https://github.com/zed-industries/zed"
SRC_URI="
	https://github.com/zed-industries/zed/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://gitlab.com/api/v4/projects/35204985/packages/generic/${PN}/${PV}/${P}-crates.tar.xz
	${CARGO_CRATE_URIS}"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0 ISC
	LGPL-3 MIT MPL-2.0 Unicode-3.0 Unicode-DFS-2016 ZLIB
"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="gles"
CHECKREQS_DISK_BUILD="8G"
CHECKREQS_MEMORY="16G"

DEPEND="
	app-arch/zstd:=
	app-misc/jq
	dev-db/sqlite:3
	dev-libs/libgit2:=
	dev-libs/mimalloc
	dev-libs/openssl:0/3
	dev-libs/protobuf
	dev-libs/wayland
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	dev-util/vulkan-tools
	media-fonts/noto
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/vulkan-loader[X]
	net-analyzer/openbsd-netcat
	net-misc/curl
	sys-libs/zlib
	x11-libs/libxcb:=
	x11-libs/libxkbcommon[X]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/cmake
	dev-util/vulkan-headers
	sys-devel/gettext
	sys-devel/mold
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
"

QA_FLAGS_IGNORED="usr/bin/zedit"

pkg_setup() {
	if tc-is-gcc; then
		export CARGO_PROFILE_RELEASE_LTO="true"
	elif tc-is-clang; then
		export CARGO_PROFILE_RELEASE_LTO="thin"
	fi
	strip-unsupported-flags
	# flags from upstream
	export RUSTFLAGS="${RUSTFLAGS} -C symbol-mangling-version=v0 --cfg tokio_unstable -C link-arg=-fuse-ld=mold -C link-args=-Wl,--disable-new-dtags,-rpath,\$ORIGIN/../lib"
	# linking error with llvm-18
	export RUSTFLAGS="${RUSTFLAGS} -C link-args=-Wl,-z,nostart-stop-gc"
	if use gles; then
		export RUSTFLAGS="${RUSTFLAGS} --cfg gles"
	fi
	llvm-r1_pkg_setup
	rust_pkg_setup
}

src_prepare() {
	default

	export APP_CLI="zedit"
	export APP_ICON="zed"
	export APP_ID="dev.zed.Zed"
	export APP_NAME="Zed"
	export APP_ARGS="%U"
	export DO_STARTUP_NOTIFY="true"
	envsubst < "crates/zed/resources/zed.desktop.in" > ${APP_ID}.desktop || die
}

src_configure() {
	cargo_src_configure --all-features
}

src_compile() {
	export RELEASE_VERSION="${PV}"
	export ZED_UPDATE_EXPLANATION='Updates are handled by portage'
	cargo_src_compile --package zed --package cli
}

src_install() {
	newbin $(cargo_target_dir)/cli ${APP_CLI}
	exeinto "/usr/libexec"
	newexe $(cargo_target_dir)/zed zed-editor

	newicon -s 512 crates/zed/resources/app-icon.png zed.png
	newicon -s 1024 crates/zed/resources/app-icon@2x.png zed.png
	domenu "${S}/${APP_ID}.desktop"
}

src_test () {
	mkdir -p "${HOME}/.config/zed" || die
	mkdir -p "${HOME}/.local/share/zed/logs/" || die

	SHELL=/usr/bin/sh RUST_BACKTRACE=full cargo_src_test -vv
}
