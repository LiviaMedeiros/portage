# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="User configurable relay-only Mail Transfer Agent with a sendmail-like syntax"
HOMEPAGE="http://esmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="
	>=net-libs/libesmtp-1.0.6_p20200824
	dev-libs/openssl:0=
"
RDEPEND="${CDEPEND}
	!mail-mta/courier
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp
	!mail-mta/opensmtpd
"
DEPEND="${CDEPEND}
	sys-devel/flex
"

PATCHES=( "${FILESDIR}/esmtp-1.2-pkgconfig.patch" )
DOCS=( AUTHORS ChangeLog NEWS README TODO sample.esmtprc )

pkg_postinst() {
	elog "A sample esmtprc file has been installed in /usr/share/doc/${P}"
}
