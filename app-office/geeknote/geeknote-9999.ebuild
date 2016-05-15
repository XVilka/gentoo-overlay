# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-r1 distutils-r1 git-2

DESCRIPTION="Evernote command line client"
HOMEPAGE="http://www.geeknote.me"
EGIT_REPO_URI="git://github.com/VitaliyRodnenko/geeknote.git"

LICENSE="GPL3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
