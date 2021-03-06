# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit elisp-common

DESCRIPTION="Rust is a curly-brace, block-structured expression language."
HOMEPAGE="http://www.rust-lang.org"
SRC_URI="http://static.rust-lang.org/dist/rust-0.6.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="emacs vim-syntax"

DEPEND="|| ( >=sys-devel/gcc-4.4[cxx] =sys-devel/clang-3 )
		>=dev-lang/python-2.6
		>=dev-lang/perl-5.0
		>=sys-devel/make-3.8.1
		net-misc/curl
		emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE="70${PN}-gentoo.el"
BYTECOMPFLAGS="-L src/etc/emacs"

src_configure() {
    if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
        ${ECONF_SOURCE:-.}/configure
    fi
}


src_compile() {

	elisp-compile src/etc/emacs/{cm,rust}-mode.el || die "elisp failed"
	emake || die "emake failed"

}

src_install() {


	emake DESTDIR="${D}" install
	
	if ! declare -p DOCS >/dev/null 2>&1 ; then
		local d
		for d in README* ChangeLog AUTHORS NEWS TODO CHANGES THANKS BUGS \
			FAQ CREDITS CHANGELOG ; do
			[[ -s "${d}" ]] && dodoc "${d}"
		done
	elif declare -p DOCS | grep -q "^declare -a " ; then
		dodoc "${DOCS[@]}"
	else
		dodoc ${DOCS}
	fi	
	exeinto /usr/bin
	doexe x86_64-unknown-linux-gnu/stage2/bin/rustc || die
	doexe x86_64-unknown-linux-gnu/stage2/bin/rustdoc || die
	insinto /usr/lib
	doins x86_64-unknown-linux-gnu/stage2/lib/librustrt.so || die
	for lib in `ls -rt1 x86_64-unknown-linux-gnu/stage2/lib/libcore-*.so | tail -1`; do
		doins ${lib} || die
	done
	for lib in `ls -rt1 x86_64-unknown-linux-gnu/stage2/lib/libstd-*.so | tail -1`; do
		doins ${lib} || die
	done
	for lib in `ls -rt1 x86_64-unknown-linux-gnu/stage2/lib/librustc-*.so | tail -1`; do
		doins ${lib} || die
	done
	doins x86_64-unknown-linux-gnu/stage2/lib/librustllvm.so || die
	doman man/rustc.1
	insinto /usr/lib/rustc/x86_64-unknown-linux-gnu/lib
	doins x86_64-unknown-linux-gnu/stage2/lib/rustc/x86_64-unknown-linux-gnu/lib/librustrt.so
	for lib in `ls -rt1 x86_64-unknown-linux-gnu/stage2/lib/rustc/x86_64-unknown-linux-gnu/lib/libcore-*.so | tail -1`; do
		doins ${lib} || die
	done
	for lib in `ls -rt1 x86_64-unknown-linux-gnu/stage2/lib/rustc/x86_64-unknown-linux-gnu/lib/libstd-*.so | tail -1`; do
		doins ${lib} || die
	done
	for lib in `ls -rt1 x86_64-unknown-linux-gnu/stage2/lib/rustc/x86_64-unknown-linux-gnu/lib/librustc-*.so | tail -1`; do
			doins ${lib} || die
	done
	doins x86_64-unknown-linux-gnu/stage2/lib/rustc/x86_64-unknown-linux-gnu/lib/libmorestack.a
	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins src/etc/vim/syntax/rust.vim || die
		insinto /usr/share/vim/vimfiles/indent
		doins src/etc/vim/indent/rust.vim || die
	fi
	if use emacs ; then
		elisp-install ${PN} src/etc/emacs/{cm,rust}-mode.{el,elc} || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
