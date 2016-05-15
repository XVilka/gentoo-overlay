# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:
# /var/cvsroot/gentoo-x86/dev-util/radare2-bindings/radare2-bindings-9999.ebuild,v 1.0 2011/12/12 06:20:21 akochkov Exp $

EAPI="5"
inherit base eutils git-2 python

DESCRIPTION="Language bindings for radare2"
HOMEPAGE="http://www.radare.org"
EGIT_REPO_URI="/home/xvilka/radare/radare2-bindings"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cxx python perl php lua nodejs guile ruby ocaml"

RDEPEND="perl? ( dev-lang/perl )
	php? ( >=dev-lang/php-5.3.12 )
	lua? ( >=dev-lang/lua-5.1.4 )
	nodejs? ( >=net-libs/nodejs-0.8.2 )
	guile? ( dev-scheme/guile )
	ruby? ( >=dev-lang/ruby-1.8.7 )
	ocaml? ( dev-lang/ocaml )"

DEPEND="${RDEPEND}
	dev-util/radare2
	dev-util/pkgconfig
	dev-util/valabind
	dev-lang/swig
	>=dev-lang/vala-0.14"

PYTHON_DEPEND="python? 2:2.7"

src_prepare() {
	base_src_prepare
}

src_configure() {
	local lang langs

	for lang in cxx python perl php lua nodejs guile ruby ; do
		if use ${lang}; then
			case ${lang} in
				php)
					lang=php5
					;;
				python)
					lang=python
					;;
			esac
			langs+=",$lang"
		fi
	done
	econf --enable=${langs:1}
}

src_compile() {
	if use nodejs; then
		cd node-ffi
	fi
	emake
}

src_install() {
	emake install-plugins || die "Install bindings failed"
}
