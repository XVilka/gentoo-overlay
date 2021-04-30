# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/degate/degate-9999.ebuild,v 2.0 2012/08/21 06:20:21 akochkov Exp $

EAPI=7
inherit cmake-utils eutils git-r3

DESCRIPTION="VLSI reverse engineering tool for digital logic"
HOMEPAGE="http://www.degate.org"
EGIT_REPO_URI="https://github.com/nitram2342/degate.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND=""
DEPEND="${RDEPEND} \
	dev-cpp/glibmm
	dev-cpp/gtkmm \
	dev-cpp/libglademm \
	dev-cpp/libxmlpp \
	dev-libs/xmlrpc-c \
	dev-util/pkgconfig"

