# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="free MASM-compatible assembler"
HOMEPAGE="http://www.japheth.de/JWasm.html"
SRC_URI="http://www.japheth.de/Download/JWasm/JWasm211as.zip"

LICENSE="sowpl"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND=""
RDEPEND="${DEPEND}"
IUSE=""
S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}/01_amd64_m32.patch"
}

src_compile() {
	cd ${WORKDIR}
	CFLAGS=-m32 make ${MAKEOPTS} -f GccUnix.mak
}

src_install() {
	mkdir -p ${D}/usr/bin
	cp ${WORKDIR}/GccUnixR/jwasm ${D}/usr/bin
}
