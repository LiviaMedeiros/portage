# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-meson

DESCRIPTION="Session Manager Proxy"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXt
	x11-libs/libXmu"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
