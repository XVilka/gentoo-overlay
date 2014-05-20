# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils-r1

DESCRIPTION="A malware identification and classification tool"
HOMEPAGE="https://plusvic.github.io/yara/"
SRC_URI="https://github.com/plusvic/yara/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="~app-forensics/yara-${PV}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/yara-${PV}/yara-python
