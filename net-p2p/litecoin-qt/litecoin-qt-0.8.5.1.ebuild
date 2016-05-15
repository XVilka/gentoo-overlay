# Copyright 2010-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/litecoin-qt/litecoin-qt-0.8.3.ebuild,v 1.1 2013/07/16 10:15:04 blueness Exp $

EAPI=4

DB_VER="4.8"

LANGS="af_ZA ar bg bs ca ca_ES cs cy da de el_GR en eo es es_CL et eu_ES fa fa_IR fi fr fr_CA gu_IN he hi_IN hr hu it ja la lt lv_LV nb nl pl pt_BR pt_PT ro_RO ru sk sr sv th_TH tr uk zh_CN zh_TW"
#LANGS=""
inherit db-use eutils fdo-mime gnome2-utils kde4-functions qt4-r2 versionator

MyPV="${PV/_/}" 
MyPN="litecoin"
MyP="${MyPN}-${MyPV}"
BaseP="bitcoin"

DESCRIPTION="An end-user Qt4 GUI for the Litecoin crypto-currency"
HOMEPAGE="http://litecoin.org" 
SRC_URI="http://litecoin.org/downloads/linux/litecoin-${MyPV}-linux.tar.xz"

LICENSE="MIT ISC GPL-3 LGPL-2.1 public-domain || ( CC-BY-SA-3.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="*"
IUSE="$IUSE 1stclassmsg dbus ipv6 kde +qrcode upnp"

RDEPEND="
	>=dev-libs/boost-1.41.0[threads(+)]
	dev-libs/openssl:0[-bindist]
	qrcode? (
		media-gfx/qrencode
	)
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	=dev-libs/leveldb-1.9.0*[-snappy]
	dev-qt/qtgui:4
	dbus? (
		dev-qt/qtdbus:4
	)
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

#DOCS="doc/README.md doc/release-notes.md"
DOCS=""

S="${WORKDIR}/${MyP}"


src_unpack() {
	echo unpack ${A}
	unpack ${A}
# The archive unpacks to an unexpected directory named ... so change it
	pwd
 	echo mv ${S}-linux ${S}
 	mv ${S}-linux ${S}
}

src_prepare() {
#	use 1stclassmsg && epatch "${WORKDIR}/0.8.2-1stclassmsg.patch"
#	epatch "${FILESDIR}/0.8.2-sys_leveldb.patch"
#	rm -r src/leveldb

	cd src/src || die

	local filt= yeslang= nolang=

	for lan in $LANGS; do
		if [ ! -e qt/locale/bitcoin_$lan.ts ]; then
			ewarn "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in $(ls qt/locale/*.ts)
	do
		x="${ts/*bitcoin_/}"
		x="${x/.ts/}"
		if ! use "linguas_$x"; then
			nolang="$nolang $x"
			rm "$ts"
			filt="$filt\\|$x"
		else
			yeslang="$yeslang $x"
		fi
	done
	filt="bitcoin_\\(${filt:2}\\)\\.\(qm\|ts\)"
	sed "/${filt}/d" -i 'qt/bitcoin.qrc'
	einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"
}

src_configure() {
	OPTS=()

	use dbus && OPTS+=("USE_DBUS=1")
	if use upnp; then
		OPTS+=("USE_UPNP=1")
	else
		OPTS+=("USE_UPNP=-")
	fi
	use qrcode && OPTS+=("USE_QRCODE=1")
	use 1stclassmsg && OPTS+=("FIRST_CLASS_MESSAGING=1")
	use ipv6 || OPTS+=("USE_IPV6=-")

	OPTS+=("USE_SYSTEM_LEVELDB=1")

	OPTS+=("BDB_INCLUDE_PATH=$(db_includedir "${DB_VER}")")
	OPTS+=("BDB_LIB_SUFFIX=-${DB_VER}")

	if has_version '>=dev-libs/boost-1.52'; then
		OPTS+=("LIBS+=-lboost_chrono\$\$BOOST_LIB_SUFFIX")
	fi

	eqmake4 "${S}/src/${BaseP}-qt.pro" "${OPTS[@]}"
}

src_test() {
	cd src/src || die
	emake -f makefile.unix "${OPTS[@]}" test_litecoin
	./test_litecoin || die 'Tests failed'
}

src_install() {
	qt4-r2_src_install
	dobin ${PN}
	cd ${S}/src || die
	insinto /usr/share/pixmaps
	newins "share/pixmaps/${BaseP}.ico" "${PN}.ico"
	make_desktop_entry ${PN} "Litecoin-Qt" "/usr/share/pixmaps/${PN}.ico" "Network;P2P"

#	doman contrib/debian/manpages/${BaseP}-qt.1

#	if use kde; then
#		insinto /usr/share/kde4/services
#		doins contrib/debian/litecoin-qt.protocol
#	fi
}

update_caches() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	buildsycoca
}

pkg_postinst() {
	update_caches
}

pkg_postrm() {
	update_caches
}
