# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs

MY_PV=$(ver_rs 3 -)
DESCRIPTION="Small daemon to relay multicast UDP traffic to client's TCP (HTTP) connection"
HOMEPAGE="https://sourceforge.net/projects/udpxy/"
SRC_URI="http://www.udpxy.com/download/1_23/${PN}.${MY_PV}-prod.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default

	tc-export CC
}

src_install() {
	dobin udpxy
	dosym udpxy /usr/bin/udpxrec

	doman doc/en/*.1
	dodoc CHANGES README

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
}
