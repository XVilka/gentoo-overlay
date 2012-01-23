# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/elinks/elinks-0.12_pre5-r1.ebuild,v 1.10 2011/06/22 02:33:17 nirbheek Exp $

EAPI="4"

inherit eutils git-2 autotools flag-o-matic

DESCRIPTION="Advanced and well-established text-mode web browser"
HOMEPAGE="http://elinks.cz/"
EGIT_REPO_URI="git://repo.or.cz/elinks.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bittorrent bzip2 debug finger ftp fsp gopher gpm guile idn ipv6 \
	  javascript lua +mouse nls nntp perl python ruby samba ssl unicode X zlib"
RESTRICT="test"

DEPEND="dev-libs/boehm-gc
	>=dev-libs/expat-1.95.4
	bzip2? ( >=app-arch/bzip2-1.0.2 )
	ssl? ( >=dev-libs/openssl-0.9.6g )
	X? ( x11-libs/libX11 x11-libs/libXt )
	zlib? ( >=sys-libs/zlib-1.1.4 )
	lua? ( >=dev-lang/lua-5 )
	gpm? ( >=sys-libs/ncurses-5.2 >=sys-libs/gpm-1.20.0-r5 )
	guile? ( >=dev-scheme/guile-1.6.4-r1[deprecated,discouraged] )
	idn? ( net-dns/libidn )
	perl? ( sys-devel/libperl )
	python? ( dev-lang/python )
	ruby? ( dev-lang/ruby dev-ruby/rubygems )
	samba? ( net-fs/samba )
	javascript? ( dev-lang/spidermonkey )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cd "${WORKDIR}"
	cd "${S}"

	epatch "${FILESDIR}"/elinks-0.11.5-makefile.patch
	epatch "${FILESDIR}"/elinks-0.12_pre5-compilation-fix.patch

	if use javascript && has_version ">=dev-lang/spidermonkey-1.8"; then
		epatch "${FILESDIR}"/elinks-0.12pre5-spidermonkey-callback.patch
	fi

	sed -i -e 's/-Werror//' configure*
	cat config/m4/*.m4 > acinclude.m4
	eautoreconf
}

src_configure() {
	# NOTE about GNUTSL SSL support (from the README -- 25/12/2002)
	# As GNUTLS is not yet 100% stable and its support in ELinks is not so well
	# tested yet, it's recommended for users to give a strong preference to OpenSSL whenever possible.
	local myconf=""

	if use debug ; then
		myconf="--enable-debug"
	else
		myconf="--enable-fastmem"
	fi

	if use ssl ; then
		myconf="${myconf} --with-openssl=${EPREFIX}/usr"
	else
		myconf="${myconf} --without-openssl --without-gnutls"
	fi

	econf \
		--sysconfdir="${EPREFIX}"/etc/elinks \
		--enable-leds \
		--enable-88-colors \
		--enable-256-colors \
		--enable-true-color \
		--enable-html-highlight \
		$(use_with gpm) \
		$(use_with zlib) \
		$(use_with bzip2 bzlib) \
		$(use_with X x) \
		$(use_with lua) \
		$(use_with guile) \
		$(use_with perl) \
		$(use_with python) \
		$(use_with ruby) \
		$(use_with idn) \
		$(use_with javascript spidermonkey) \
		$(use_enable bittorrent) \
		$(use_enable nls) \
		$(use_enable ipv6) \
		$(use_enable ftp) \
		$(use_enable fsp) \
		$(use_enable gopher) \
		$(use_enable nntp) \
		$(use_enable finger) \
		$(use_enable samba smb) \
		$(use_enable mouse) \
		${myconf}
}

src_install() {
	make DESTDIR="${D}" install || die

	insopts -m 644 ; insinto /etc/elinks
	#doins "${WORKDIR}"/elinks.conf
	newins contrib/keybind-full.conf keybind-full.sample
	newins contrib/keybind.conf keybind.conf.sample

	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README SITES THANKS TODO doc/*.*
	docinto contrib ; dodoc contrib/{README,colws.diff,elinks[-.]vim*}
	insinto /usr/share/doc/${PF}/contrib/lua ; doins contrib/lua/{*.lua,elinks-remote}
	insinto /usr/share/doc/${PF}/contrib/conv ; doins contrib/conv/*.*
	insinto /usr/share/doc/${PF}/contrib/guile ; doins contrib/guile/*.scm

	# Remove some conflicting files on OSX.  The files provided by OSX 10.4
	# are more or less the same.  -- Fabian Groffen (2005-06-30)
	rm -f "${ED}"/usr/share/locale/locale.alias "${ED}"/usr/lib/charset.alias
}

pkg_postinst() {
	einfo "You may want to convert your html.cfg and links.cfg of"
	einfo "Links or older ELinks versions to the new ELinks elinks.conf"
	einfo "using /usr/share/doc/${PF}/contrib/conv/conf-links2elinks.pl"
	einfo
	einfo "Please have a look at /etc/elinks/keybind-full.sample and"
	einfo "/etc/elinks/keybind.conf.sample for some bindings examples."
	einfo
	einfo "You will have to set your TERM variable to 'xterm-256color'"
	einfo "to be able to use 256 colors in elinks."
	echo
}
