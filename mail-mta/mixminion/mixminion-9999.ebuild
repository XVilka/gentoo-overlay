# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git-2

DESCRIPTION="A Type III Anonymous Remailer"
HOMEPAGE="http://mixminion.net"
EGIT_REPO_URI="git://gitorious.org/mixminion/mixminion.git"
S="${WORKDIR}/Mixminion-git"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/openssl-0.9.7
	>=dev-lang/python-2.6"

RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup mixminion
	enewuser mixminion -1 -1 /var/lib/mixminion mixminion
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	exeinto /etc/init.d ; newexe ${FILESDIR}/mixminion.initd mixminion
	insinto /etc/mixminion ; newins ${S}/etc/mixminiond.conf mixminiond.conf.sample

	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README ACKS TODO HACKING LICENSE HISTORY \
		doc/{statusfd.txt,tutorial.txt}

	keepdir /var/lib/mixminion
	keepdir /var/spool/mixminion
	keepdir /var/log/mixminion
	keepdir /var/run/mixminion
	fperms 700 /var/lib/mixminion /var/log/mixminion /var/spool/mixminion
	fperms 755 /var/run/mixminion
	fowners mixminion:mixminion /var/lib/mixminion /var/log/mixminion /var/run/mixminion

}

