# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bap/bap-0.7.ebuild,v 2.0 2012/04/04 06:20:21 akochkov Exp $

EAPI=5
inherit base eutils

DESCRIPTION="Advanced command line hexadecimal editor and more"
HOMEPAGE="http://www.radare.org"
SRC_URI="http://bap.ece.cmu.edu/download/bap-0.7.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!dev-util/bap
	dev-lang/ocaml
	dev-ml/camlidl
	dev-ml/camomile"

