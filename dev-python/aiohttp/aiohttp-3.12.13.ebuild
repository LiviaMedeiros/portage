# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="HTTP client/server for asyncio"
HOMEPAGE="
	https://github.com/aio-libs/aiohttp/
	https://pypi.org/project/aiohttp/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="+native-extensions test-rust"

DEPEND="
	native-extensions? (
		$(python_gen_cond_dep '
			net-libs/llhttp:=
		' 'python3*')
	)
"
RDEPEND="
	${DEPEND}
	>=dev-python/aiodns-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/aiohappyeyeballs-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/aiosignal-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/attrs-17.3.0[${PYTHON_USEDEP}]
	dev-python/brotlicffi[${PYTHON_USEDEP}]
	>=dev-python/frozenlist-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/multidict-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/propcache-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/yarl-1.17.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/multidict-4.5.0[${PYTHON_USEDEP}]
	native-extensions? (
		>=dev-python/cython-3.1.1[${PYTHON_USEDEP}]
		dev-python/pkgconfig[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/blockbuster[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/isal[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/re-assert[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/time-machine[${PYTHON_USEDEP}]
		' 'python3*')
		dev-python/zlib-ng[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
		test-rust? (
			dev-python/trustme[${PYTHON_USEDEP}]
		)
	)
"

DOCS=( CHANGES.rst CONTRIBUTORS.txt README.rst )

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# increase the timeout a little
	sed -e '/abs=/s/0.001/0.01/' -i tests/test_helpers.py || die
	# xfail_strict fails on py3.10
	sed -i -e '/--cov/d' -e '/pytest_cov/d' -e '/xfail_strict/d' setup.cfg || die
	sed -i -e 's:-Werror::' Makefile || die
	# remove vendored llhttp
	rm -r vendor || die
}

python_configure() {
	# check for .install-cython, so that we do this only once
	if [[ ! -f .install-cython && ${EPYTHON} != pypy3 ]] &&
		use native-extensions
	then
		# force rehashing first
		emake requirements/.hash/cython.txt.hash
		> .update-pip || die
		> .install-cython || die
		emake cythonize
	fi
}

python_compile() {
	local -x AIOHTTP_USE_SYSTEM_DEPS=1
	# implicitly disabled for pypy3
	if [[ ${EPYTHON} == pypy3* ]] || ! use native-extensions; then
		local -x AIOHTTP_NO_EXTENSIONS=1
	fi

	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_IGNORE=(
		# proxy is not packaged
		tests/test_proxy_functional.py
		# python_on_whales is not packaged
		tests/autobahn/test_autobahn.py
		# benchmarks
		tests/test_benchmarks_client.py
		tests/test_benchmarks_client_request.py
		tests/test_benchmarks_client_ws.py
		tests/test_benchmarks_cookiejar.py
		tests/test_benchmarks_http_websocket.py
		tests/test_benchmarks_http_writer.py
		tests/test_benchmarks_web_fileresponse.py
		tests/test_benchmarks_web_middleware.py
		tests/test_benchmarks_web_response.py
		tests/test_benchmarks_web_urldispatcher.py
	)

	local EPYTEST_DESELECT=(
		# Internet
		tests/test_client_session.py::test_client_session_timeout_zero
		tests/test_connector.py::test_tcp_connector_ssl_shutdown_timeout_nonzero_passed
		tests/test_connector.py::test_tcp_connector_ssl_shutdown_timeout_passed_to_create_connection
		tests/test_connector.py::test_tcp_connector_ssl_shutdown_timeout_zero_not_passed
		# broken by irrelevant deprecation warnings
		tests/test_circular_imports.py::test_no_warnings
	)

	case ${EPYTHON} in
		python3.14)
			EPYTEST_DESELECT+=(
				# TODO
				tests/test_cookiejar.py::test_pickle_format
				# different exception message
				tests/test_client_functional.py::test_aiohttp_request_coroutine
			)
			;;
	esac

	# upstream unconditionally blocks building C extensions
	# on PyPy3 but the test suite needs an explicit switch
	if [[ ${EPYTHON} == pypy3* ]] || ! use native-extensions; then
		local -x AIOHTTP_NO_EXTENSIONS=1
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_mock,xdist.plugin
	rm -rf aiohttp || die
	epytest -m "not internal and not dev_mode" \
		-p rerunfailures --reruns=5
}
