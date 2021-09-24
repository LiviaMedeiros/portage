# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PV="${PV/_pre*}"
MY_P="pulseaudio-${MY_PV}"

inherit bash-completion-r1 gnome2-utils meson optfeature systemd tmpfiles udev

DESCRIPTION="A networked sound server with an advanced plugin system"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/pulseaudio/pulseaudio"
else
	SRC_URI="https://freedesktop.org/software/pulseaudio/releases/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

S="${WORKDIR}/${MY_P}"

# libpulse-simple and libpulse link to libpulse-core; this is daemon's
# library and can link to gdbm and other GPL-only libraries. In this
# cases, we have a fully GPL-2 package. Leaving the rest of the
# GPL-forcing USE flags for those who use them.
LICENSE="!gdbm? ( LGPL-2.1 ) gdbm? ( GPL-2 )"

SLOT="0"

# +alsa-plugin as discussed in bug #519530
# TODO: Deal with bluez5-gstreamer - requires ldacenc and rtpldacpay gstreamer elements
# TODO: Find out why webrtc-aec is + prefixed - there's already the always available speexdsp-aec
# NOTE: The current ebuild sets +X almost certainly just for the pulseaudio.desktop file
IUSE="+alsa +alsa-plugin +asyncns bluetooth dbus elogind equalizer +gdbm gstreamer +glib gtk ipv6 jack lirc
native-headset ofono-headset +orc oss selinux sox ssl systemd system-wide tcpd test +udev +webrtc-aec +X zeroconf"

RESTRICT="!test? ( test )"

# See "*** BLUEZ support not found (requires D-Bus)" in configure.ac
# Basically all IUSE are either ${MULTILIB_USEDEP} for client libs or they belong under !daemon ()
# We duplicate alsa-plugin, {native,ofono}-headset under daemon to let users deal with them at once
REQUIRED_USE="
	alsa-plugin? ( alsa )
	bluetooth? ( dbus )
	?? ( elogind systemd )
	equalizer? ( dbus )
	native-headset? ( bluetooth )
	ofono-headset? ( bluetooth )
	udev? ( || ( alsa oss ) )
	zeroconf? ( dbus )
"

# NOTE:
# - libpcre needed in some cases, bug #472228
# - media-libs/speexdsp is providing echo canceller implementation and used in resampler
# TODO: libatomic_ops is only needed on some architectures and conditions, and then at runtime too
COMMON_DEPEND="
	>=media-libs/libpulse-${PV}[glib?]
	dev-libs/libatomic_ops
	>=media-libs/libsndfile-1.0.20
	>=media-libs/speexdsp-1.2
	|| (
		elibc_glibc? ( virtual/libc )
		elibc_uclibc? ( virtual/libc )
		dev-libs/libpcre:3
	)
	alsa? ( >=media-libs/alsa-lib-1.0.24 )
	asyncns? ( >=net-libs/libasyncns-0.1 )
	bluetooth? (
		>=net-wireless/bluez-5
		media-libs/sbc
	)
	dev-libs/libltdl
	sys-kernel/linux-headers
	>=sys-libs/libcap-2.22-r2
	dbus? ( >=sys-apps/dbus-1.4.12 )
	elogind? ( sys-auth/elogind )
	equalizer? (
		sci-libs/fftw:3.0
	)
	gdbm? ( sys-libs/gdbm:= )
	glib? ( >=dev-libs/glib-2.28.0:2 )
	gstreamer? (
		media-libs/gst-plugins-base
		>=media-libs/gstreamer-1.14
	)
	gtk? ( x11-libs/gtk+:3 )
	jack? ( virtual/jack )
	lirc? ( app-misc/lirc )
	ofono-headset? ( >=net-misc/ofono-1.13 )
	orc? ( >=dev-lang/orc-0.4.15 )
	selinux? ( sec-policy/selinux-pulseaudio )
	sox? ( >=media-libs/soxr-0.1.1 )
	ssl? ( dev-libs/openssl:= )
	systemd? ( sys-apps/systemd:= )
	tcpd? ( sys-apps/tcp-wrappers )
	udev? ( >=virtual/udev-143[hwdb(+)] )
	webrtc-aec? ( >=media-libs/webrtc-audio-processing-0.2:0 )
	X? (
		>=x11-libs/libxcb-1.6
		x11-libs/libICE
		x11-libs/libSM
		>=x11-libs/libX11-1.4.0
		>=x11-libs/libXtst-1.0.99.2
	)
	zeroconf? ( >=net-dns/avahi-0.6.12[dbus] )
	!<media-sound/pulseaudio-15.0-r100
"

# pulseaudio ships a bundle xmltoman, which uses XML::Parser
DEPEND="
	${COMMON_DEPEND}
	test? ( >=dev-libs/check-0.9.10 )
	X? ( x11-base/xorg-proto )
"

# alsa-utils dep is for the alsasound init.d script (see bug 155707); TODO: read it
# NOTE: Only system-wide needs acct-group/audio unless elogind/systemd is not used
RDEPEND="
	${COMMON_DEPEND}
	system-wide? (
		alsa? ( media-sound/alsa-utils )
		acct-user/pulse
		acct-group/audio
		acct-group/pulse-access
	)
"

# This is a PDEPEND to avoid a circular dep
PDEPEND="
	alsa? ( alsa-plugin? ( >=media-plugins/alsa-plugins-1.0.27-r1[pulseaudio] ) )
"

BDEPEND="
	dev-lang/perl
	dev-perl/XML-Parser
	sys-devel/gettext
	virtual/libiconv
	virtual/libintl
	virtual/pkgconfig
	orc? ( >=dev-lang/orc-0.4.15 )
	system-wide? ( dev-util/unifdef )
"

DOCS=( NEWS README )

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/pulseaudio-15.0-xice-xsm-xtst-daemon-only.patch
	"${FILESDIR}"/${PV}-daemon-only.patch
)

src_prepare() {
	default

	gnome2_environment_reset
}

src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var

		-Ddaemon=true
		-Ddaemon-only=true
		-Ddoxygen=false
		-Dgcov=false
		-Dman=true
		# tests involve random modules, so just do them for the native # TODO: tests should run always
		$(meson_use test tests)
		-Ddatabase=$(usex gdbm gdbm simple) # tdb is also an option but no one cares about it
		-Dstream-restore-clear-old-devices=true
		-Drunning-from-build-tree=false

		# Paths
		-Dmodlibexecdir="${EPREFIX}/usr/$(get_libdir)/pulseaudio/modules" # Was $(get_libdir)/${P}
		-Dsystemduserunitdir=$(systemd_get_userunitdir)
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
		-Dbashcompletiondir="$(get_bashcompdir)" # Alternatively DEPEND on app-shells/bash-completion for pkg-config to provide the value

		# Optional features
		$(meson_feature alsa)
		$(meson_feature asyncns)
		$(meson_feature zeroconf avahi)
		$(meson_feature bluetooth bluez5)
		-Dbluez5-gstreamer=disabled # no ldacenc/rtpldacpay gst elements packaged yet
		$(meson_use native-headset bluez5-native-headset)
		$(meson_use ofono-headset bluez5-ofono-headset)
		$(meson_feature dbus)
		$(meson_feature elogind)
		$(meson_feature equalizer fftw)
		$(meson_feature glib) # WARNING: toggling this likely changes ABI
		$(meson_feature glib gsettings) # Supposedly correct?
		$(meson_feature gstreamer)
		$(meson_feature gtk)
		-Dhal-compat=true # Consider disabling on next revbump
		$(meson_use ipv6)
		$(meson_feature jack)
		$(meson_feature lirc)
		$(meson_feature ssl openssl)
		$(meson_feature orc)
		$(meson_feature oss oss-output)
		-Dsamplerate=disabled # Matches upstream
		$(meson_feature sox soxr)
		-Dspeex=enabled
		$(meson_feature systemd)
		$(meson_feature tcpd tcpwrap) # TODO: This should technically be enabled for 32bit too, but at runtime it probably is never used without daemon?
		$(meson_feature udev)
		-Dvalgrind=auto
		$(meson_feature X x11)

		# Echo cancellation
		-Dadrian-aec=false # Not packaged?
		$(meson_feature webrtc-aec)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# Installed by media-libs/libpulse
	rm "${ED}/$(get_bashcompdir)"/pulseaudio || die

	if use system-wide; then
		newconfd "${FILESDIR}"/pulseaudio.conf.d pulseaudio

		use_define() {
			local define=${2:-$(echo ${1} | tr '[:lower:]' '[:upper:]')}

			use "${1}" && echo "-D${define}" || echo "-U${define}"
		}

		unifdef -x 1 \
			$(use_define zeroconf AVAHI) \
			$(use_define alsa) \
			$(use_define bluetooth) \
			$(use_define udev) \
			"${FILESDIR}"/pulseaudio.init.d-5 \
			> "${T}"/pulseaudio \
			|| die

		doinitd "${T}"/pulseaudio

		systemd_dounit "${FILESDIR}"/pulseaudio.service

		# We need /var/run/pulse, bug 442852
		newtmpfiles "${FILESDIR}"/pulseaudio.tmpfiles pulseaudio.conf
	else
		# Prevent warnings when system-wide is not used, bug 447694
		if use dbus; then
			rm "${ED}"/etc/dbus-1/system.d/pulseaudio-system.conf || die
		fi
	fi

	if use zeroconf; then
		sed -i \
			-e '/module-zeroconf-publish/s:^#::' \
			"${ED}/etc/pulse/default.pa" \
			|| die
	fi

	find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_postinst() {
	gnome2_schemas_update

	if use system-wide; then
		tmpfiles_process "pulseaudio.conf"

		elog "You have enabled the 'system-wide' USE flag for pulseaudio."
		elog "This mode should only be used on headless servers, embedded systems,"
		elog "or thin clients. It will usually require manual configuration, and is"
		elog "incompatible with many expected pulseaudio features."
		elog "On normal desktop systems, system-wide mode is STRONGLY DISCOURAGED."
		elog ""
		elog "For more information, see"
		elog "    https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/WhatIsWrongWithSystemWide/"
		elog "    https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/SystemWide/"
		elog "    https://wiki.gentoo.org/wiki/PulseAudio#Headless_server"
		elog ""
	fi

	if use equalizer; then
		elog "You will need to load some extra modules to make qpaeq work."
		elog "You can do that by adding the following two lines in"
		elog "/etc/pulse/default.pa and restarting pulseaudio:"
		elog "load-module module-equalizer-sink"
		elog "load-module module-dbus-protocol"
		elog ""
	fi

	if use native-headset && use ofono-headset; then
		elog "You have enabled both native and ofono headset profiles. The runtime decision"
		elog "which to use is done via the 'headset' argument of module-bluetooth-discover."
		elog ""
	fi

	if use systemd; then
		elog "It's recommended to start pulseaudio via its systemd user units:"
		elog ""
		elog "  systemctl --user enable pulseaudio.service pulseaudio.socket"
		elog ""
		elog "The change from autospawn to user units will take effect after restarting."
		elog ""
	fi

	optfeature_header "PulseAudio can be enhanced by installing the following:"
	use equalizer && optfeature "using the qpaeq script" dev-python/PyQt5[dbus,widgets]
	use dbus && optfeature "restricted realtime capabilities via D-Bus" sys-auth/rtkit
}

pkg_postrm() {
	gnome2_schemas_update
}
