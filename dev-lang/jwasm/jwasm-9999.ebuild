# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils git-r3

DESCRIPTION="free MASM-compatible assembler"
HOMEPAGE="http://jwasm.info"
EGIT_REPO_URI="https://github.com/JWasm/JWasm.git"

LICENSE="sowpl"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND=""
RDEPEND="${DEPEND}"
IUSE=""

src_compile() {
	make ${MAKEOPTS} -f GccUnix.mak
}

src_install() {
	mkdir -p ${D}/usr/bin
	cp ${S}/GccUnixR/jwasm ${D}/usr/bin || die "No jwasm"
}
