# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake llvm.org llvm-utils python-any-r1

DESCRIPTION="OCaml bindings for LLVM"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-4.00.0:0=
	dev-ml/ocaml-ctypes:=
	~llvm-core/llvm-${PV}:=[debug?]
	!llvm-core/llvm[ocaml(-)]
"

DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
	dev-ml/findlib
"

LLVM_COMPONENTS=( llvm cmake third-party )
LLVM_USE_TARGETS=llvm
llvm.org_set_globals

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}

		-DBUILD_SHARED_LIBS=OFF
		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DLLVM_LINK_LLVM_DYLIB=ON
		-DLLVM_OCAML_OUT_OF_TREE=ON

		# cheap hack: LLVM combines both anyway, and the only difference
		# is that the former list is explicitly verified at cmake time
		-DLLVM_TARGETS_TO_BUILD=""
		-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
		-DLLVM_BUILD_TESTS=$(usex test)

		# disable various irrelevant deps and settings
		-DLLVM_ENABLE_FFI=OFF
		-DLLVM_ENABLE_TERMINFO=OFF
		-DHAVE_HISTEDIT_H=NO
		-DLLVM_ENABLE_ASSERTIONS=$(usex debug)
		-DLLVM_ENABLE_EH=ON
		-DLLVM_ENABLE_RTTI=ON

		-DLLVM_HOST_TRIPLE="${CHOST}"

		-DPython3_EXECUTABLE="${PYTHON}"

		# TODO: ocamldoc
	)

	use test && mycmakeargs+=(
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	# also: custom rules for OCaml do not work for CPPFLAGS
	use debug || local -x CFLAGS="${CFLAGS} -DNDEBUG"
	cmake_src_configure

	local llvm_libdir=$(llvm-config --libdir)
	# an ugly hack; TODO: figure out a way to pass -L to ocaml...
	cd "${BUILD_DIR}/${libdir}" || die
	ln -s "${llvm_libdir}"/*.so . || die

	if use test; then
		local llvm_bindir=$(llvm-config --bindir)
		# Force using system-installed tools.
		sed -i -e "/llvm_tools_dir/s@\".*\"@\"${llvm_bindir}\"@" \
			"${BUILD_DIR}"/test/lit.site.cfg.py || die
	fi
}

src_compile() {
	cmake_build ocaml_all
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-llvm-bindings-ocaml
}

src_install() {
	DESTDIR="${D}" \
	cmake -P "${BUILD_DIR}"/bindings/ocaml/cmake_install.cmake || die

	dodoc bindings/ocaml/README.txt
}
