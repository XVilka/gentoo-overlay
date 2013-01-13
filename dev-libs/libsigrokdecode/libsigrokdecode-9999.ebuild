# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base autotools eutils git-2

DESCRIPTION="Protocol decoder library for sigrok"
HOMEPAGE="http://www.sigrok.org"
EGIT_REPO_URI="git://sigrok.org/libsigrokdecode"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/glib-2.28
	>=dev-lang/python-3.0"
RDEPEND="${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" INSTALL_PROGRAM="install" install || die "install failed"
}

