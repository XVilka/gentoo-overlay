# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/radare2/radare2-9999.ebuild,v 2.0 2012/04/04 06:20:21 akochkov Exp $

EAPI=5
inherit base eutils git-2

DESCRIPTION="Patched 0.x QEMU version for the debugging ARM BootRoms"
HOMEPAGE="https://github.com/XVilka/qemu"
EGIT_REPO_URI="/home/xvilka/radare/qemu"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	econf --target-list=arm-softmmu
}

src_install() {
	emake DESTDIR="${D}" INSTALL_PROGRAM="install" install || die "install failed"
}
