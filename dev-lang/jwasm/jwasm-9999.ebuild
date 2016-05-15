# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils git-2

DESCRIPTION="free MASM-compatible assembler"
HOMEPAGE="http://jwasm.info"
EGIT_REPO_URI="git://github.com/JWasm/JWasm.git"

LICENSE="sowpl"
SLOT="0"
KEYWORDS="~x86 ~amd64"
DEPEND=""
RDEPEND="${DEPEND}"
IUSE=""
S="${WORKDIR}"

src_compile() {
	cd ${WORKDIR}
	make ${MAKEOPTS} -f GccUnix.mak
}

src_install() {
	mkdir -p ${D}/usr/bin
	cp ${WORKDIR}/GccUnixR/jwasm ${D}/usr/bin
}
