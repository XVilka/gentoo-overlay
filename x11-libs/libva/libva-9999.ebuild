# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libva/libva-0.31.1_p5.ebuild,v 1.1 2011/02/03 14:15:01 aballier Exp $

EAPI="2"
inherit eutils autotools
inherit git

PLEVEL=${PV##*_p}
MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Video Acceleration (VA) API for Linux"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/vaapi"
EGIT_REPO_URI="http://anongit.freedesktop.org/git/libva.git"
EGIT_BRANCH="master"
EGIT_STORE_DIR="${DISTDIR}/git-src"
EGIT_PROJECT="${PN/-git}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

VIDEO_CARDS="dummy nvidia intel" # fglrx
for x in ${VIDEO_CARDS}; do
	IUSE+=" video_cards_${x}"
done

RDEPEND=">=x11-libs/libdrm-2.4
	video_cards_intel? ( >=x11-libs/libdrm-2.4.23 )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	opengl? ( virtual/opengl )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"
PDEPEND="video_cards_nvidia? ( x11-libs/vdpau-video )"
	#video_cards_fglrx? ( x11-libs/xvba-video )

S=${WORKDIR}/${MY_P}

src_unpack() {
	git_src_unpack
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
	$(use_enable video_cards_dummy dummy-driver) \
	$(use_enable video_cards_intel i965-driver) \
	$(use_enable opengl glx)
}

src_install() {
	rm -R "${S}"/.git
	emake DESTDIR="${D}" install || die "make install failed"
	find "${D}" -name '*.la' -delete
}
