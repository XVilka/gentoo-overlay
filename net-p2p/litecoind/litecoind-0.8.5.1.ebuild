# Copyright 2010-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bitcoind/bitcoind-0.8.3-r1.ebuild,v 1.1 2013/07/27 07:26:40 pacho Exp $

EAPI="4"

DB_VER="4.8"

inherit db-use eutils versionator systemd toolchain-funcs

MyPV="${PV/_/}" 
MyPN="litecoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="Litecoin - a lite version of Bitcoin optimized for CPU mining using scrypt as a proof of work scheme."
HOMEPAGE="http://litecoin.org" 
SRC_URI="http://litecoin.org/downloads/linux/litecoin-${MyPV}-linux.tar.xz"

LICENSE="MIT ISC GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="examples ipv6 logrotate upnp"

RDEPEND="
	>=dev-libs/boost-1.41.0[threads(+)]
	dev-libs/openssl:0[-bindist]
	logrotate? (
		app-admin/logrotate
	)
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	=dev-libs/leveldb-1.9.0*[-snappy]
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"

S="${WORKDIR}/${MyP}"

pkg_setup() {
	local UG='litecoin'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/litecoin "${UG}"
}

src_unpack() {
	echo unpack ${A}
	unpack ${A}
# The archive unpacks to an unexpected directory named ... so change it
	pwd
 	echo mv ${S}-linux ${S}
 	mv ${S}-linux ${S}
}

src_prepare() {
#	epatch "${FILESDIR}/0.8.2-sys_leveldb.patch"
#	rm -r src/leveldb

	if has_version '>=dev-libs/boost-1.52'; then
		sed -i 's/\(-l db_cxx\)/-l boost_chrono$(BOOST_LIB_SUFFIX) \1/' src/makefile.unix
	fi
}

src_compile() {
	OPTS=()

	OPTS+=("DEBUGFLAGS=")
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=("LDFLAGS=${LDFLAGS}")

	OPTS+=("BDB_INCLUDE_PATH=$(db_includedir "${DB_VER}")")
	OPTS+=("BDB_LIB_SUFFIX=-${DB_VER}")

	if use upnp; then
		OPTS+=(USE_UPNP=1)
	else
		OPTS+=(USE_UPNP=)
	fi
	use ipv6 || OPTS+=("USE_IPV6=-")

	OPTS+=("USE_SYSTEM_LEVELDB=1")

	cd src/src || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" ${PN}
}

src_test() {
	cd src/src || die
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" -f makefile.unix "${OPTS[@]}" test_bitcoin
	./test_litecoin || die 'Tests failed'
}

src_install() {
	dobin src/src/${PN}

	insinto /etc/litecoin
	newins "${FILESDIR}/litecoin.conf" litecoin.conf
	fowners litecoin:litecoin /etc/litecoin/litecoin.conf
	fperms 600 /etc/litecoin/litecoin.conf

	newconfd "${FILESDIR}/litecoin.confd" ${PN}
	newinitd "${FILESDIR}/litecoin.initd" ${PN}
#	systemd_dounit "${FILESDIR}/litecoind.service"

	keepdir /var/lib/litecoin/.litecoin
	fperms 700 /var/lib/litecoin
	fowners litecoin:litecoin /var/lib/litecoin/
	fowners litecoin:litecoin /var/lib/litecoin/.litecoin
	dosym /etc/litecoin/litecoin.conf /var/lib/litecoin/.litecoin/litecoin.conf

#	dodoc doc/README.md
#	dodoc doc/release-notes.md
#	doman contrib/debian/manpages/{litecoind.1,litecoin.conf.5}

#	if use bash-completion; then
#		insinto /usr/share/bash-completion
#		newins contrib/litecoind.bash-completion litecoind
#	fi

#	if use examples; then
#		docinto examples
#	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/litecoind.logrotate" litecoind
	fi
}
