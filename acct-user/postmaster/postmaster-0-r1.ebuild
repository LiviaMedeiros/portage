# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="Postmaster user"
ACCT_USER_ID=14
ACCT_USER_HOME=/var/spool/mail
ACCT_USER_HOME_OWNER=root:mail
ACCT_USER_HOME_PERMS=03775
ACCT_USER_GROUPS=( mail )

acct-user_add_deps
