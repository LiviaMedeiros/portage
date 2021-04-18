# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

DESCRIPTION="pcc portable c compiler"
HOMEPAGE="http://pcc.ludd.ltu.se"

if [[ ${PV} == 9999 ]]; then
	ECVS_SERVER="pcc.ludd.ltu.se:/cvsroot"
	ECVS_MODULE="${PN}"
	inherit cvs

	S="${WORKDIR}/${PN}"
else
	SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

DEPEND=">=dev-libs/pcc-libs-${PV}"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/AC_CHECK_PROG(strip,strip,yes,no)//' configure.ac || die "Failed to fix configure.ac"
	sed -i -e 's/AC_SUBST(strip)//' configure.ac || die "Failed to fix configure.ac more"
	eautoreconf
}

src_configure() {
	econf --disable-stripping
}

src_install() {
	emake DESTDIR="${D}" install
}
