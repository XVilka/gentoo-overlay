# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git

DESCRIPTION="Prototype constraint-based diagram editor"
HOMEPAGE="http://www.csse.monash.edu.au/~mwybrow/dunnart/"
EGIT_REPO_URI="git://github.com/mjwybrow/dunnart.git"
S="${WORKDIR}/dunnart-git"

LICENSE="GPL"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/qt-gui-4.0"

RDEPEND="${DEPEND}"

src_compile() {
	qmake -recursive -config release dunnart.pro
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

