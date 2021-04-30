# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit eutils git-r3

LICENSE="OWPL-1"
DESCRIPTION="The Open Watcom compiler"
HOMEPAGE="http://www.openwatcom.org"
EGIT_REPO_URI="https://github.com/open-watcom/open-watcom-v2.git"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE="examples source"

DEPEND="sys-devel/gcc"

RESTRICT="strip"
S=${WORKDIR}/OW9999

src_compile() {
	./build.sh || die "build.sh failed"
}

src_install() {
	mkdir -p "${D}"/opt
	cp -R rel2 "${D}"/opt/openwatcom
	ln -s binl "${D}"/opt/openwatcom/bin

	use examples || rm -rf "${D}"/opt/openwatcom/samples
	use source || rm -rf "${D}"/opt/openwatcom/src

	INSTALL_DIR=/opt/openwatcom

	local env_file=05${PN}
	cat > ${env_file} <<-EOF
		WATCOM=${INSTALL_DIR}
		INCLUDE=${INSTALL_DIR}/lh
		PATH=${INSTALL_DIR}/binl
	EOF
	doenvd ${env_file} || die "doenvd ${env_file} failed"
}
