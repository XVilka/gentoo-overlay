# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils toolchain-funcs multilib

DESCRIPTION="Luvit takes node.js' architecture and dependencies and fits it in the Lua language"
HOMEPAGE="http://luvit.io/"
SRC_URI="http://${PN}.io/dist/${PV}/${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE="custom-cflags"
LICENSE="Apache-2.0 MIT"

# TODO: ebuilds for http-parser and libuv which are used for luvit
# https://github.com/joyent/http-parser
# https://github.com/joyent/libuv
DEPEND="dev-lang/luajit:2
	>=dev-libs/yajl-2.0.2[static-libs]
	dev-util/pkgconfig"
RDEPEND=""

src_prepare() {
	# patch Makefile for multilib and respect flags and
	# don't use bundled sources for luajit and yajl
	epatch "${FILESDIR}"/0.2.0-makefile.patch
	sed -e "s:@LIBDIR@:$(get_libdir):" \
		-e "s:^YAJL_VERSION=.*:YAJL_VERSION=$(pkg-config --modversion yajl):" \
		-e "s:^LUAJIT_VERSION=.*:LUAJIT_VERSION=$(pkg-config --modversion luajit):" \
		-i Makefile || die "sed failed"
}

src_configure() {
	# skip python build system
	:
}

src_compile() {
	# custom CFLAGS are problematic
	use custom-cflags || unset CFLAGS
	emake AR=$(tc-getAR) CC=$(tc-getCC)
}

src_install() {
	# EPREFIX untested
	emake PREFIX=/usr DESTDIR="${ED}" install
}
