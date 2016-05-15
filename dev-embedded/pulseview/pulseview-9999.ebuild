# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit cmake-utils git-2

DESCRIPTION="Qt based logical analyzer UI for sigrok"
HOMEPAGE="http://www.sigrok.org"
EGIT_REPO_URI="git://sigrok.org/pulseview"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost
	>=dev-libs/glib-2.28
	dev-libs/libsigrok
	dev-libs/libsigrokdecode
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	virtual/pkgconfig"

CMAKE_IN_SOURCE_BUILD=1

