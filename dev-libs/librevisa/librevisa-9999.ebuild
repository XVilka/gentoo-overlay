# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base autotools eutils git-2

DESCRIPTION="Library for VISA standard for interfacing test and measurement equipment"
HOMEPAGE="http://www.librevisa.org/"
EGIT_REPO_URI="http://www.librevisa.org/git/librevisa.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/glib-2.32"
RDEPEND="${DEPEND}
	virtual/pkgconfig
	virtual/udev"

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" INSTALL_PROGRAM="install" install || die "install failed"
}

