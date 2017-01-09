# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit flag-o-matic autotools

DESCRIPTION="a sat-solver developed by RISE."
HOMEPAGE="http://http://z3.codeplex.com/"
SRC_URI=""
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-libs/boost-1.32 >=dev-lang/python-3.2.5-r1 >=sys-devel/automake-1.12.6"
RDEPEND="${DEPEND}"

src_configure() {
git clone https://git01.codeplex.com/z3 .
eautoconf
strip-flags
./configure --prefix=/usr --build=x86_64-pc-linux-gnu --mandir=/usr/share/man --infodir=/usr/share/info --datadir=/usr/share --sysconfdir=/etc --localstatedir=/var/lib --libdir=/usr/lib64
python scripts/mk_make.py
}

src_compile() {
	cd build
	emake || die "emake failed"
}

src_install() {
cd /var/tmp/portage/sci-misc/z3-4.3.1/
ln -s image usr
echo 'cd work/build; make install' > finish.sh
chmod a+x finish.sh
chroot . ./finish.sh

}
