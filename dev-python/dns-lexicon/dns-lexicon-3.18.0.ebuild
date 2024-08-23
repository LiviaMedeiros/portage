# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 optfeature

DESCRIPTION="Manipulate DNS records on various DNS providers in a standardized/agnostic way"
HOMEPAGE="
	https://github.com/AnalogJ/lexicon/
	https://pypi.org/project/dns-lexicon/
"
SRC_URI="
	https://github.com/AnalogJ/lexicon/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/lexicon-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	>=dev-python/dnspython-2[${PYTHON_USEDEP}]
	>=dev-python/pyotp-2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tldextract[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/boto3-1.25[${PYTHON_USEDEP}]
		dev-python/zeep[${PYTHON_USEDEP}]
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO
	tests/test_client.py::test_client_init_when_missing_action_should_fail
)

EPYTEST_IGNORE=(
	# Requires the "localzone" module
	tests/providers/test_localzone.py
	# Requires the "softlayer" module
	tests/providers/test_softlayer.py
	# Requires the "transip" module
	tests/providers/test_transip.py
	# Requires the "oci" module
	tests/providers/test_oci.py
	# Uses tldextract which needs Internet access to download its database
	tests/providers/test_auto.py
)

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		optfeature_header \
			"Install the following packages to enable support for additional DNS providers:"
		optfeature Gransy dev-python/zeep
		optfeature Route53 dev-python/boto3
		optfeature DDNS dev-python/dnspython
	fi
}
