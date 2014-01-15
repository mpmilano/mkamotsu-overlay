EAPI=5

DESCRIPTION="ocaml package manager"
HOMEPAGE="opam.ocamlpro.com"
SRC_URI="http://www.ocamlpro.com/pub/opam-full-1.0.0.tar.gz"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/ocaml-4.00.0"
RDEPEND="${DEPEND}"


src_unpack() {
    if [ "${A}" != "" ]; then
        unpack ${A}
    fi
    cd ${S}
    ln -s opam-* opam-1.0.0
    echo "SOMETHING IS HAPPENING"
}
