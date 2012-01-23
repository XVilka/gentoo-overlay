# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libinfinity/libinfinity-0.4.2.ebuild,v 1.1 2010/11/22 08:01:17 xarthisius Exp $

EAPI=2

inherit eutils versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="An implementation of the Infinote protocol written in GObject-based C."
HOMEPAGE="http://gobby.0x539.de/"
SRC_URI="http://releases.0x539.de/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="avahi doc gtk server static-libs"

RDEPEND="dev-libs/glib:2
	dev-libs/libxml2
	net-libs/gnutls
	>=virtual/gsasl-0.2.21
	avahi? ( net-dns/avahi )
	gtk? ( >=x11-libs/gtk+-2.12:2 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.23
	doc? ( dev-util/gtk-doc )"

pkg_setup() {
	if use server ; then
		enewgroup infinote 100
		enewuser infinote 100 /bin/bash /var/lib/infinote infinote
	fi
}

src_configure() {
	econf \
		$(use_enable doc gtk-doc) \
		$(use_with gtk inftextgtk) \
		$(use_with gtk infgtk) \
		$(use_with server infinoted) \
		$(use_enable static-libs static) \
		$(use_with avahi) \
		$(use_with avahi libdaemon)
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}" -name "*.la" -delete

	dodoc AUTHORS NEWS README TODO || die

	if use server ; then
		newinitd "${FILESDIR}/infinoted.initd" infinoted
		newconfd "${FILESDIR}/infinoted.confd" infinoted

		keepdir /var/lib/infinote
		fowners infinote:infinote /var/lib/infinote
		fperms 770 /var/lib/infinote

		dosym /usr/bin/infinoted-${MY_PV} /usr/bin/infinoted

		elog "Add local users who should have local access to the documents"
		elog "created by infinoted to the infinote group."
		elog "The documents are saved in /var/lib/infinote per default."
	fi
}
