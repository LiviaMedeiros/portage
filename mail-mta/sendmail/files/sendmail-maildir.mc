divert(-1)
divert(0)dnl
include(`/usr/share/sendmail-cf/m4/cf.m4')dnl
VERSIONID(`$Id$')dnl
OSTYPE(linux)dnl
DOMAIN(generic)dnl
FEATURE(`smrsh',`/usr/sbin/smrsh')dnl
FEATURE(`local_lmtp',`/usr/sbin/mail.local')dnl
FEATURE(`local_procmail')dnl
dnl FEATURE(`local_procmail',`/usr/bin/maildrop',`maildrop -d $u')dnl
MAILER(local)dnl
MAILER(smtp)dnl
MAILER(procmail)dnl
