# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/radare2/radare2-9999.ebuild,v 2.0 2012/04/04 06:20:21 akochkov Exp $

EAPI=5
inherit base eutils autotools git-r3

DESCRIPTION="TSM - Terminal Emulator State Machine"
HOMEPAGE="http://cgit.freedesktop.org/~dvdhrm/libtsm"
EGIT_REPO_URI="git://people.freedesktop.org/~dvdhrm/libtsm"
EGIT_COMMIT="bb4e454"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	mkdir -p m4
	autoreconf -is --force
}

src_install() {
	emake DESTDIR="${D}" INSTALL_PROGRAM="install" install || die "install failed"
}
