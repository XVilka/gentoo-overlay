# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/valabind/valabind-9999.ebuild,v 1.0 2011/12/07 06:20:21 akochkov Exp $

EAPI=5
inherit base eutils git-2

DESCRIPTION="Valabind is a tool to parse vala or vapi files to transform them into swig files"
HOMEPAGE="http://github.com/radare/valabind"
EGIT_REPO_URI="git://github.com/radare/valabind.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/swig
	>=dev-lang/vala-0.14"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	base_src_prepare
}

src_compile() {
	emake -j1 || die "compile failed"
}

src_install() {
	emake DESTDIR="${ED}" install || die "install failed"
}
