# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_GEMSPEC="pg.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md Contributors.rdoc README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Ruby extension library providing an API to PostgreSQL"
HOMEPAGE="https://github.com/ged/ruby-pg"
SRC_URI="https://github.com/ged/ruby-pg/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-${P}"

LICENSE="|| ( BSD-2 Ruby-BSD )"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

RDEPEND=">=dev-db/postgresql-10:*"
DEPEND="dev-db/postgresql
	test? ( >=dev-db/postgresql-10[server(+),threads(+)] )"

all_ruby_prepare() {
	# hack the Rakefile to make it sure that it doesn't load
	# rake-compiler (so that we don't have to depend on it and it
	# actually works when building with USE=doc).
	sed -i \
		-e '/Rakefile.cross/s:^:#:' \
		-e '/ExtensionTask/,/^end$/ s:^:#:' \
		Rakefile || die

	sed -e 's/git ls-files -z/find * -print0/' \
		-e "s:_relative ': './:" \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Don't allow sudo calls that try to tinker with /etc/hosts (bug #933234)
	sed -e '/sudo/ s:^:#:' -i spec/helpers.rb || die
	sed -e '/refreshes DNS address while conn.reset/ s/it/xit/' \
		-i spec/pg/connection_spec.rb || die
	sed -e '/doesn.t duplicate hosts in conn.reset/ s/it/xit/' \
		-i spec/pg/connection_async_spec.rb || die

	# Avoid tests that assume IPv4
	sed -i -e '/expect.*hostaddr/ s:^:#:' spec/pg/connection_spec.rb || die

	# Fails with network-sandbox
	sed -i -e '/connects using without host but envirinment variables/askip "gentoo"' spec/pg/scheduler_spec.rb || die

	# Avoid test that only works with bundled pg
	sed -i -e '/tells about the libpq library path/askip "gentoo"' spec/pg_spec.rb || die
}

each_ruby_test() {
	if [[ "${EUID}" -ne "0" ]]; then
		# Make the rspec call explicit, this way we don't have to depend
		# on rake-compiler (nor rubygems) _and_ we don't have to rebuild
		# the whole extension from scratch.
		RSPEC_VERSION=3 ruby-ng_rspec
	else
		ewarn "The userpriv feature must be enabled to run tests."
		eerror "Testsuite will not be run."
	fi
}
