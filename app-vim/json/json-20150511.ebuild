# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vim-plugin

DESCRIPTION="vim plugin: a better JSON for Vim"
HOMEPAGE="https://github.com/elzr/vim-json/"
LICENSE="MIT"
KEYWORDS="amd64 x86"

src_prepare() {
	rm *-test.* license.md || die
}
