# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )

inherit distutils-r1

DESCRIPTION="A malware identification and classification tool"
HOMEPAGE="https://virustotal.github.io/yara-python/"
SRC_URI="https://github.com/VirusTotal/yara-python/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="~app-forensics/yara-${PV}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/yara-${PV}/yara-python
