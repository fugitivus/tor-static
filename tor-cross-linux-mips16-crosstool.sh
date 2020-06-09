# Tor Static Cross compile From Linux64 to MIPS32
# Tested on Debian 10 (Buster) 64bit

# Crosstool-ng needs to be installed & toolchain for ... 
# have to be compiled & $PATH variables to be set e.g:
# export PATH="${PATH}:/home/fugitivus/x-tools/mips-unknown-linux-uclibc/bin"
# See Crosstool-NG documentation for more details.
# https://crosstool-ng.github.io/docs/

# Download required dependencies to build tor:
    wget http://zlib.net/zlib-1.2.11.tar.gz
    wget https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz
    wget https://www.openssl.org/source/openssl-1.0.2j.tar.gz
    wget https://www.torproject.org/dist/tor-0.4.2.7.tar.gz

# extract downloaded Packages:
    tar xfv zlib-1.2.11.tar.gz
    tar xfv libevent-2.1.11-stable.tar.gz
    tar xfv openssl-1.0.2j.tar.gz
    tar xfv tor-0.4.2.7.tar.gz
    
# Build Zlib:
	cd zlib-1.2.11
    export CC="mips-unknown-linux-uclibc-gcc -static -Os"
    ./configure --prefix="$HOME/git/crosstool-ng/workdir/zlib-1.2.11/install"
    make BINARY_PATH=$PREFIXDIR/bin INCLUDE_PATH=$PREFIXDIR/include LIBRARY_PATH=$PREFIXDIR/lib SHARED_MODE=1 install
	cd ..
    
# Build libevent:
    cd libevent-2.1.11-stable
    export CC="mips-unknown-linux-uclibc-gcc -Os" 
    ./configure --prefix="$HOME/git/crosstool-ng/workdir/libevent-2.1.11-stable/install" --enable-static --disable-shared LDFLAGS="-static"
    make
    make install
    cd ..
    
# Build openssl:
    cd openssl-1.0.2j
    export CC="mips-unknown-linux-uclibc-gcc -Os"
    export LDFLAGS="-static -static-libgcc" 
    
    ./Configure linux-generic32 shared --prefix="$HOME/git/crosstool-ng/workdir/openssl-1.0.2j/install/" 
    #--cross-compile-prefix="/usr/bin/arm-linux-gnueabihf-"

    make && make install
    cd ..
	
# Build Tor:
    cd tor-0.4.2.7
    export CC="mips-unknown-linux-uclibc-gcc -Os"
    #export LIBS="-lssl -lcrypto -lpthread -ldl"
    export LDFLAGS="-static -static-libgcc"
    export CFLAGS="-I$HOME/git/crosstool-ng/workdir/openssl-1.0.2j/install/lib/include -I$HOME/git/crosstool-ng/workdir/zlib-1.2.8 -I$HOME/git/crosstool-ng/workdir/libevent-2.1.11-stable/install/include"

    ./configure --enable-static-tor --prefix="$HOME/tor/install" --with-libevent-dir="$HOME/git/crosstool-ng/workdir/libevent-2.1.11-stable/install/" --with-openssl-dir="$HOME/git/crosstool-ng/workdir/openssl-1.0.2j/install/" --with-zlib-dir="$HOME/git/crosstool-ng/workdir/zlib-1.2.11" --disable-lzma --disable-zstd #--disable-tool-name-check

    make
    make install
    cd ..

# cleanup:
    rm zlib-1.2.11.tar.gz
    rm libevent-2.1.11-stable.tar.gz
    rm openssl-1.0.2j.tar.gz
    rm tor-0.4.2.7.tar.gz
    rm -r zlib-1.2.11
    rm -r libevent-2.1.11-stable
    rm -r openssl-1.0.2j
    rm -r tor-0.4.2.7
