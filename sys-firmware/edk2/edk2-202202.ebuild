# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{10..11} )

inherit python-any-r1 readme.gentoo-r1 secureboot

DESCRIPTION="UEFI firmware for 64-bit x86 virtual machines"
HOMEPAGE="https://github.com/tianocore/edk2"

BUNDLED_OPENSSL_SUBMODULE_SHA="d82e959e621a3d597f1e0d50ff8c2d8b96915fd7"
BUNDLED_BROTLI_SUBMODULE_SHA="f4153a09f87cbb9c826d8fc12c74642bb2d879ea"

# TODO: talk with tamiko about unbundling (mva)

# TODO: the binary 202105 package currently lacks the preseeded
#       OVMF_VARS.secboot.fd file (that we typically get from fedora)

SRC_URI="https://github.com/tianocore/edk2/archive/edk2-stable${PV}.tar.gz -> edk2-ovmf-${PV}.tar.gz
	https://github.com/openssl/openssl/archive/${BUNDLED_OPENSSL_SUBMODULE_SHA}.tar.gz -> openssl-${BUNDLED_OPENSSL_SUBMODULE_SHA}.tar.gz
	https://github.com/google/brotli/archive/${BUNDLED_BROTLI_SUBMODULE_SHA}.tar.gz -> brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}.tar.gz
	https://dev.gentoo.org/~ajak/distfiles/edk2-ovmf-${PV}-qemu-firmware.tar.xz"

LICENSE="BSD-2-with-patent MIT"
SLOT="0"
KEYWORDS="-* amd64"

BDEPEND="app-emulation/qemu
	>=dev-lang/nasm-2.0.7
	sys-apps/which
	>=sys-power/iasl-20160729
	${PYTHON_DEPS}"
RDEPEND="!sys-firmware/edk2-bin"

PATCHES=(
	"${FILESDIR}/${PN}-202105-werror.patch"
	"${FILESDIR}/${PN}-202202-lld-textrels.patch"
	"${FILESDIR}/${PN}-202202-binutils-2.41-textrels.patch"
)

S="${WORKDIR}/edk2-edk2-stable${PV}"

DISABLE_AUTOFORMATTING=true
DOC_CONTENTS="This package contains the tianocore edk2 UEFI firmware for 64-bit x86
virtual machines. The firmware is located under
	/usr/share/edk2-ovmf/OVMF_CODE.fd
	/usr/share/edk2-ovmf/OVMF_VARS.fd
	/usr/share/edk2-ovmf/OVMF_CODE.secboot.fd

To use Secure Boot, you need to either populate the necessary EFI
variables by booting:
	/usr/share/edk2-ovmf/UefiShell.img
or creating OVMF_VARS.secboot.fd by hand:
	https://github.com/rhuefi/qemu-ovmf-secureboot

The firmware does not support csm (due to no free csm implementation
available). If you need a firmware with csm support you have to download
one for yourself. Firmware blobs are commonly labeled
	OVMF{,_CODE,_VARS}-with-csm.fd

In order to use the firmware you can run qemu the following way

	$ qemu-system-x86_64 \
		-drive file=/usr/share/edk2-ovmf/OVMF.fd,if=pflash,format=raw,unit=0,readonly=on \
		..."

pkg_setup() {
	python-any-r1_pkg_setup
	secureboot_pkg_setup
}

src_prepare() {
	# Bundled submodules
	cp -rl "${WORKDIR}/openssl-${BUNDLED_OPENSSL_SUBMODULE_SHA}"/* "CryptoPkg/Library/OpensslLib/openssl/"
	cp -rl "${WORKDIR}/brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}"/* "BaseTools/Source/C/BrotliCompress/brotli/"
	cp -rl "${WORKDIR}/brotli-${BUNDLED_BROTLI_SUBMODULE_SHA}"/* "MdeModulePkg/Library/BrotliCustomDecompressLib/brotli/"

	sed -i -r \
		-e "/function SetupPython3/,/\}/{s,\\\$\(whereis python3\),${EPYTHON},g}" \
		"${S}"/edksetup.sh || die "Fixing for correct Python3 support failed"

	default
}

src_compile() {
	TARGET_ARCH=X64
	TARGET_NAME=RELEASE
	TARGET_TOOLS=GCC49

	BUILD_FLAGS="-D TLS_ENABLE \
		-D HTTP_BOOT_ENABLE \
		-D NETWORK_IP6_ENABLE \
		-D TPM_ENABLE \
		-D TPM2_ENABLE -D TPM2_CONFIG_ENABLE \
		-D FD_SIZE_2MB"

	SECUREBOOT_BUILD_FLAGS="${BUILD_FLAGS} \
		-D SECURE_BOOT_ENABLE \
		-D SMM_REQUIRE \
		-D EXCLUDE_SHELL_FROM_FD"

	export LDFLAGS="-z notext"
	export EXTRA_LDFLAGS="-z notext"
	export DLINK_FLAGS="-z notext"

	emake ARCH=${TARGET_ARCH} -C BaseTools

	. ./edksetup.sh

	# Build all EFI firmware blobs:

	mkdir -p ovmf

	./OvmfPkg/build.sh \
		-a "${TARGET_ARCH}" -b "${TARGET_NAME}" -t "${TARGET_TOOLS}" \
		${BUILD_FLAGS} || die "OvmfPkg/build.sh failed"

	cp Build/OvmfX64/*/FV/OVMF_*.fd ovmf/
	rm -rf Build/OvmfX64

	./OvmfPkg/build.sh \
		-a "${TARGET_ARCH}" -b "${TARGET_NAME}" -t "${TARGET_TOOLS}" \
		${SECUREBOOT_BUILD_FLAGS} || die "OvmfPkg/build.sh failed"

	cp Build/OvmfX64/*/FV/OVMF_CODE.fd ovmf/OVMF_CODE.secboot.fd || die "cp failed"
	cp Build/OvmfX64/*/X64/Shell.efi ovmf/ || die "cp failed"
	cp Build/OvmfX64/*/X64/EnrollDefaultKeys.efi ovmf || die "cp failed"

	# Build a convenience UefiShell.img:

	mkdir -p iso_image/efi/boot || die "mkdir failed"
	cp ovmf/Shell.efi iso_image/efi/boot/bootx64.efi || die "cp failed"
	cp ovmf/EnrollDefaultKeys.efi iso_image || die "cp failed"
	qemu-img convert --image-opts \
		driver=vvfat,floppy=on,fat-type=12,label=UEFI_SHELL,dir=iso_image \
		ovmf/UefiShell.img || die "qemu-img failed"
}

src_install() {
	insinto /usr/share/edk2-ovmf
	doins ovmf/*

	insinto /usr/share/qemu/firmware
	doins qemu/*
	rm "${ED}"/usr/share/qemu/firmware/40-edk2-ovmf-x64-sb-enrolled.json || die "rm failed"

	secureboot_auto_sign --in-place

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
