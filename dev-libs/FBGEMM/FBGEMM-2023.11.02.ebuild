# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
inherit python-any-r1 flag-o-matic cmake

CommitId=cdae5d97e3aa9fda4222f31c04dbd80249c918d1

DESCRIPTION="Facebook GEneral Matrix Multiplication"
HOMEPAGE="https://github.com/pytorch/FBGEMM"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="
	>=dev-libs/asmjit-2022.07.02
	dev-libs/cpuinfo
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? ( dev-cpp/gtest )
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
			dev-python/breathe[${PYTHON_USEDEP}]
		')
	)
	${PYTHON_DEPS}
"
RESTRICT="!test? ( test )"

python_check_deps() {
	if use doc; then
		python_has_version \
			"dev-python/sphinx[${PYTHON_USEDEP}]" \
			"dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]" \
			"dev-python/breathe[${PYTHON_USEDEP}]"
	fi
}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	# Bug #855668
	filter-lto

	rm test/RowWiseSparseAdagradFusedTest.cc || die
	rm test/SparseAdagradTest.cc || die
	sed -i \
		-e "/-Werror/d" \
		CMakeLists.txt \
		|| die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFBGEMM_LIBRARY_TYPE=shared
		-DFBGEMM_BUILD_BENCHMARKS=OFF
		-DFBGEMM_BUILD_DOCS=$(usex doc ON OFF)
		-DFBGEMM_BUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_test() {
	OMP_STACKSIZE=512k cmake_src_test
}
