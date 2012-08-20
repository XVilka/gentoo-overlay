# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/radare2/radare2-9999.ebuild,v 2.0 2012/04/04 06:20:21 akochkov Exp $

EAPI="4"
inherit base eutils git-2

DESCRIPTION="Advanced command line hexadecimal editor and more"
HOMEPAGE="http://www.radare.org"
EGIT_REPO_URI="http://radare.org/git/radare2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ssl ewf gmp debug"

RDEPEND="ssl? ( dev-libs/openssl ) \
		gmp? ( dev-libs/gmp ) "
DEPEND="${RDEPEND} \
	!dev-util/radare \
	dev-util/pkgconfig"

src_configure() {
	econf $(use ssl || echo --without-ssl ) \
		$(use gmp || echo --without-gmp ) \
		$(use ewf || echo --without-ewf )
}

src_install() {
	emake DESTDIR="${D}" INSTALL_PROGRAM="install" install || die "install failed"
}
