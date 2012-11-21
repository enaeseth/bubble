COMMON = bin lib include share share/downloads share/packages

bin:
	mkdir -p bin
include:
	mkdir -p include
lib:
	mkdir -p lib
share:
	mkdir -p share
share/downloads: share
	mkdir -p share/downloads
share/packages: share
	mkdir -p share/packages
share/bubble.base:
	pwd > $@

share/downloads/pcre-8.31.tar.bz2:
	wget http://sourceforge.net/projects/pcre/files/pcre/8.31/pcre-8.31.tar.bz2/download -O $@

share/downloads/pcre-8.31: share/downloads/pcre-8.31.tar.bz2
	cd `dirname $@` && tar -xjf $(notdir $<)

share/packages/pcre/8.31: share/downloads/pcre-8.31 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@ --enable-unicode-properties --enable-jit
	cd $< && make install

pcre-8.31: share/packages/pcre/8.31

pcre: pcre-8.31

share/downloads/ncurses-5.9.tar.gz:
	wget http://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.9.tar.gz -O $@

share/downloads/ncurses-5.9: share/downloads/ncurses-5.9.tar.gz
	cd `dirname $@` && tar -xzf $(notdir $<)

share/packages/ncurses/5.9: share/downloads/ncurses-5.9 share/bubble.base
	cd $< && CFLAGS="-fPIC" ./configure --prefix=`cat ../../bubble.base`/$@ --enable-widec --enable-ext-colors
	cd $< && make install

ncurses-5.9: share/packages/ncurses/5.9

ncurses: ncurses-5.9

share/downloads/zsh-5.0.0.tar.bz2:
	wget http://sourceforge.net/projects/zsh/files/zsh/5.0.0/zsh-5.0.0.tar.bz2/download -O $@

share/downloads/zsh-5.0.0: share/downloads/zsh-5.0.0.tar.bz2
	cd `dirname $@` && tar -xjf $(notdir $<)

share/packages/zsh/5.0.0: share/downloads/zsh-5.0.0 share/packages/pcre/8.31 share/packages/ncurses/5.9 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@ --enable-multibyte --enable-pcre --enable-cppflags="-I$$(cat ../../bubble.base)/share/packages/pcre/8.31/include -I$$(cat ../../bubble.base)/share/packages/ncurses/5.9/include" --enable-ldflags="-L$$(cat ../../bubble.base)/share/packages/pcre/8.31/lib -L$$(cat ../../bubble.base)/share/packages/ncurses/5.9/lib"
	cd $< && make install

zsh-5.0.0: share/packages/zsh/5.0.0

bin/zsh: bin
	-cd bin && ln -s ../share/packages/zsh/5.0.0/bin/zsh .

zsh: zsh-5.0.0 bin/zsh

share/downloads/vim-7.3.tar.bz2:
	wget ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2 -O $@

share/downloads/vim73: share/downloads/vim-7.3.tar.bz2
	cd `dirname $@` && tar -xjf $(notdir $<)

share/packages/vim/7.3: share/downloads/vim73 share/packages/pcre/8.31 share/packages/ncurses/5.9 share/bubble.base
	cd $< && CPPFLAGS="-I$$(cat ../../bubble.base)/share/packages/pcre/8.31/include -I$$(cat ../../bubble.base)/share/packages/ncurses/5.9/include" LDFLAGS="-L$$(cat ../../bubble.base)/share/packages/pcre/8.31/lib -L$$(cat ../../bubble.base)/share/packages/ncurses/5.9/lib" ./configure --prefix=`cat ../../bubble.base`/$@ --enable-multibyte --with-compiledby=Bubble --with-tlib=ncursesw --with-features=huge
	cd $< && make install

vim-7.3: share/packages/vim/7.3

bin/vim: bin
	-cd bin && ln -s ../share/packages/vim/7.3/bin/vim .

vim: vim-7.3 bin/vim

share/downloads/zlib-1.2.7.tar.gz:
	wget http://zlib.net/zlib-1.2.7.tar.gz -O $@

share/downloads/zlib-1.2.7: share/downloads/zlib-1.2.7.tar.gz
	cd `dirname $@` && tar -xzf $(notdir $<)

share/packages/zlib/1.2.7: share/downloads/zlib-1.2.7 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@
	cd $< && make install

zlib-1.2.7: share/packages/zlib/1.2.7

zlib: zlib-1.2.7

share/downloads/openssl-1.0.1c.tar.gz:
	wget http://www.openssl.org/source/openssl-1.0.1c.tar.gz -O $@

share/downloads/openssl-1.0.1c: share/downloads/openssl-1.0.1c.tar.gz
	cd `dirname $@` && tar -xzf $(notdir $<)

share/packages/openssl/1.0.1c: share/downloads/openssl-1.0.1c share/packages/zlib/1.2.7 share/bubble.base
	cd $< && ./config shared zlib zlib-dynamic --prefix=`cat ../../bubble.base`/$@ --openssldir=`cat ../../bubble.base`/$@/ssl --with-zlib-include=`cat ../../bubble.base`/share/packages/zlib/1.2.7/include --with-zlib-lib=`cat ../../bubble.base`/share/packages/zlib/1.2.7/lib -fPIC
	cd $< && make install

openssl-1.0.1c: share/packages/openssl/1.0.1c

bin/openssl: bin
	-cd bin && ln -s ../share/packages/openssl/1.0.1c/bin/openssl .

openssl: openssl-1.0.1c bin/openssl

share/downloads/curl-7.28.1.tar.bz2:
	wget http://curl.haxx.se/download/curl-7.28.1.tar.bz2 -O $@

share/downloads/curl-7.28.1: share/downloads/curl-7.28.1.tar.bz2
	cd `dirname $@` && tar -xjf $(notdir $<)

share/packages/curl/7.28.1: share/downloads/curl-7.28.1 share/packages/openssl/1.0.1c share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@ --with-ssl=`cat ../../bubble.base`/packages/openssl/1.0.1c/ssl
	cd $< && make install

curl-7.28.1: share/packages/curl/7.28.1

bin/curl: bin
	-cd bin && ln -s ../share/packages/curl/7.28.1/bin/curl .

curl: curl-7.28.1 bin/curl

share/downloads/gettext-0.18.1.1.tar.gz:
	wget http://mirrors.kernel.org/gnu/gettext/gettext-0.18.1.1.tar.gz -O $@

share/downloads/gettext-0.18.1.1: share/downloads/gettext-0.18.1.1.tar.gz
	cd `dirname $@` && tar -xzf $(notdir $<)
	cd $@ && wget -O - https://trac.macports.org/export/99886/trunk/dports/devel/gettext/files/stpncpy.patch | patch -p0

share/packages/gettext/0.18.1.1: share/downloads/gettext-0.18.1.1 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@
	cd $< && make -j4
	cd $< && make install

gettext-0.18.1.1: share/packages/gettext/0.18.1.1

gettext: gettext-0.18.1.1

share/downloads/xz-5.0.4.tar.bz2:
	wget http://tukaani.org/xz/xz-5.0.4.tar.bz2 -O $@

share/downloads/xz-5.0.4: share/downloads/xz-5.0.4.tar.bz2
	cd `dirname $@` && tar -xjf $(notdir $<)

share/packages/xz/5.0.4: share/downloads/xz-5.0.4 share/bubble.base
	cd $< && CPPFLAGS="-I$$(cat ../../bubble.base)/share/packages/gettext/0.18.1.1/include" LDFLAGS="-L$$(cat ../../bubble.base)/share/packages/gettext/0.18.1.1/lib" ./configure --prefix=`cat ../../bubble.base`/$@
	cd $< && make install

xz-5.0.4: share/packages/xz/5.0.4

bin/xz: bin
	-cd bin && ln -s ../share/packages/xz/5.0.4/bin/xz .
bin/xzdec: bin
	-cd bin && ln -s ../share/packages/xz/5.0.4/bin/xzdec .

xz: xz-5.0.4 bin/xz bin/xzdec

share/downloads/libiconv-1.14.tar.gz:
	wget http://mirrors.kernel.org/gnu/libiconv/libiconv-1.14.tar.gz -O $@

share/downloads/libiconv-1.14: share/downloads/libiconv-1.14.tar.gz
	cd `dirname $@` && tar -xzf $(notdir $<)

share/packages/libiconv/1.14: share/downloads/libiconv-1.14 share/packages/gettext/0.18.1.1 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@ --with-libintl-prefix=`cat ../../bubble.base`/share/packages/gettext/0.18.1.1
	cd $< && make -j4
	cd $< && make install

libiconv-1.14: share/packages/libiconv/1.14

libiconv: libiconv-1.14

share/downloads/pth-2.0.7.tar.gz:
	wget http://mirrors.kernel.org/gnu/pth/pth-2.0.7.tar.gz -O $@

share/downloads/pth-2.0.7: share/downloads/pth-2.0.7.tar.gz
	cd `dirname $@` && tar -xzf $(notdir $<)

share/packages/pth/2.0.7: share/downloads/pth-2.0.7 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@
	cd $< && make install
	cd $< && make test

pth-2.0.7: share/packages/pth/2.0.7

pth: pth-2.0.7

share/downloads/gzip-1.5.tar.xz:
	wget http://mirrors.kernel.org/gnu/gzip/gzip-1.5.tar.xz -O $@

share/downloads/gzip-1.5: share/downloads/gzip-1.5.tar.xz share/packages/xz/5.0.4
	cd `dirname $@` && `cat ../bubble.base`/share/packages/xz/5.0.4/bin/xzdec $(notdir $<) | tar -x

share/packages/gzip/1.5: share/downloads/gzip-1.5 share/packages/pth/2.0.7 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@ --with-libpth-prefix=`cat ../../bubble.base`/share/packages/pth/2.0.7
	cd $< && make -j4
	cd $< && make install

gzip-1.5: share/packages/gzip/1.5

bin/gzip: share/packages/gzip/1.5
	cd bin && ln -s ../$</$@ .
bin/gunzip: share/packages/gzip/1.5
	cd bin && ln -s ../$</$@ .
bin/zcat: share/packages/gzip/1.5
	cd bin && ln -s ../$</$@ .

gzip: gzip-1.5 bin/gzip bin/gunzip bin/zcat

share/downloads/bzip-1.0.6.tar.gz:
	wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz -O $@

share/downloads/bzip2-1.0.6: share/downloads/bzip-1.0.6.tar.gz
	cd `dirname $@` && tar -xzf $(notdir $<)

share/packages/bzip/1.0.6: share/downloads/bzip2-1.0.6 share/bubble.base
	cd $< && make install PREFIX=`cat ../../bubble.base`/$@

bzip-1.0.6: share/packages/bzip/1.0.6

bin/bzip2: share/packages/bzip/1.0.6
	cd bin && ln -s ../$</$@ .
bin/bunzip2: share/packages/bzip/1.0.6
	cd bin && ln -s ../$</$@ .
bin/bzcat: share/packages/bzip/1.0.6
	cd bin && ln -s ../$</$@ .

bzip: bzip-1.0.6 bin/bzip2 bin/bunzip2 bin/bzcat

share/downloads/tar-1.26.tar.xz:
	wget http://mirrors.kernel.org/gnu/tar/tar-1.26.tar.xz -O $@

share/downloads/tar-1.26: share/downloads/tar-1.26.tar.xz share/packages/xz/5.0.4
	cd `dirname $@` && `cat ../bubble.base`/share/packages/xz/5.0.4/bin/xzdec $(notdir $<) | tar -x

share/packages/tar/1.26: share/downloads/tar-1.26 share/packages/gettext/0.18.1.1 share/packages/libiconv/1.14 share/packages/xz/5.0.4 share/packages/gzip/1.5 share/packages/bzip/1.0.6 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@ --with-libiconv-prefix=`cat ../../bubble.base`/share/packages/gettext/0.18.1.1 --with-libintl-prefix=`cat ../../bubble.base`/share/packages/gettext/0.18.1.1 --with-gzip=`cat ../../bubble.base`/share/packages/gzip/1.5/bin/gzip --with-bzip2=`cat ../../bubble.base`/share/packages/bzip/1.0.6/bin/bzip2 --with-lzma=`cat ../../bubble.base`/share/packages/xz/5.0.4/lzma --with-xz=`cat ../../bubble.base`/share/packages/xz/5.0.4/xz
	cd $< && make -j4
	cd $< && make install

tar-1.26: share/packages/tar/1.26

bin/tar: share/packages/tar/1.26
	cd bin && ln -s ../$</$@ .

tar: tar-1.26 bin/tar

share/downloads/coreutils-8.20.tar.xz:
	wget http://mirrors.kernel.org/gnu/coreutils/coreutils-8.20.tar.xz -O $@

share/downloads/coreutils-8.20: share/downloads/coreutils-8.20.tar.xz share/packages/xz/5.0.4
	cd `dirname $@` && `cat ../bubble.base`/share/packages/xz/5.0.4/bin/xzdec $(notdir $<) | tar -x

share/packages/coreutils/8.20: share/downloads/coreutils-8.20 share/packages/gettext/0.18.1.1 share/bubble.base
	cd $< && ./configure --prefix=`cat ../../bubble.base`/$@ --with-libintl-prefix=`cat ../../bubble.base`/share/packages/gettext/0.18.1.1
	cd $< && make -j4
	cd $< && make install

coreutils-8.20: share/packages/coreutils/8.20

bin/.coreutils:
	cd bin && ln -s ../share/packages/coreutils/8.20/bin/* .
	touch bin/.coreutils

coreutils: coreutils-8.20 bin/.coreutils

share/downloads/git-1.8.0.tar.gz:
	wget https://github.com/git/git/archive/v1.8.0.tar.gz -O $@

share/downloads/git-1.8.0: share/downloads/git-1.8.0.tar.gz
	cd `dirname $@` && tar -xzf $(notdir $<)

share/packages/git/1.8.0: share/downloads/git-1.8.0 share/packages/openssl/1.0.1c share/packages/gettext/0.18.1.1 share/packages/curl/7.28.1 share/packages/libiconv/1.14 share/packages/pcre/8.31 share/bubble.base
	cd $< && make configure
	cd $< && CPPFLAGS="-I$$(cat ../../bubble.base)/share/packages/gettext/0.18.1.1/include" LDFLAGS="-L$$(cat ../../bubble.base)/share/packages/gettext/0.18.1.1/lib" ./configure --prefix=`cat ../../bubble.base`/$@ --with-sane-tool-path=`cat ../../bubble.base`/share/packages/gettext/0.18.1.1/bin --with-iconv=`cat ../../bubble.base`/share/packages/libiconv/1.1.4 --with-libpcre=`cat ../../bubble.base`/share/packages/pcre/8.31 --with-openssl=`cat ../../bubble.base`/share/packages/openssl/1.0.1c --with-curl=`cat ../../bubble.base`/share/packages/curl/7.28.1
	cd $< && make -j4
	cd $< && make install

git-1.8.0: share/packages/git/1.8.0

bin/git: bin
	-cd bin && ln -s ../share/packages/git/1.8.0/bin/git .

git: git-1.8.0 bin/git

init: $(COMMON)

all: init coreutils zsh vim git xz bzip gzip tar
