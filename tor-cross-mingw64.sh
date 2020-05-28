# Tor Static Cross compile From Linux to Windows10(64bit)
# Tested on Debian 10 (Buster) 64bit


# Install Cross-Compiler-Environment:
    apt-get update && apt-get upgrade -y
    apt-get install -y build-essential wget gcc libcrypto++-dev
    apt-get install -y gcc-multilib mingw-w64
    apt-get install -y make autoconf pkg-config-mingw-w64-x86-64
    apt-get install -y pkg-config-mingw-w64-i686 gcc-mingw-w64-i686
    apt-get install -y binutils-mingw-w64-i686 binutils-mingw-w64-x86-64
    apt-get install -y libz-mingw-w64 libz-mingw-w64-dev pkg-config-mingw-w64-i686
    apt-get install -y pkg-config-mingw-w64-x86-64 libgcrypt-mingw-w64-dev
    apt-get install -y binutils-mingw-w64 gcc-mingw-w64 pkg-config-mingw-w64-i686
    apt-get install -y g++-mingw-w64-x86-64 g++-mingw-w64-i686 g++-mingw-w64    
        
# Download required dependencies to build tor:
    cd /
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
    export LDFLAGS="-L/usr/x86_64-w64-mingw32/lib/"
    export CHOST="x86_64-w64-mingw32"
    export PREFIXDIR="/zlib-1.2.11/win64-cross"
    
    #on windress errors, uncomment next lines (32/64Bit)
    #ln -s /usr/bin/i686-w64-mingw32-windres /usr/bin/windres
    #ln -s /usr/bin/x86_64-w64-mingw32-windres /usr/bin/windres
    
	cd zlib-1.2.11
    make -f win32/Makefile.gcc BINARY_PATH=$PREFIXDIR/bin INCLUDE_PATH=$PREFIXDIR/include LIBRARY_PATH=$PREFIXDIR/lib SHARED_MODE=1 PREFIX=x86_64-w64-mingw32- install
	cd ..
    
# Build libevent:
    cd libevent-2.1.11-stable
    ./configure --prefix="/libevent-2.1.11-stable/install" --enable-static --disable-shared --host=x86_64-w64-mingw32
    make && make install
    cd ..
    
# Build openssl:
    cd /openssl-1.0.2j
    export CFLAGS="-I/usr/x86_64-w64-mingw32/lib/"
    export LDFLAGS="-static -static-libgcc -L/usr/x86_64-w64-mingw32/lib/" 

    ./Configure no-shared no-zlib no-asm --cross-compile-prefix=x86_64-w64-mingw32- --prefix="/openssl-1.0.2j/install/" -static -static-libgcc mingw64
    make && make install
    cd..
	
# Build Tor:
    cd /tor-0.4.2.7
    export LIBS="-lcrypt32"
    export LDFLAGS="-static -static-libgcc -L/usr/x86_64-w64-mingw32/lib/"
    export CFLAGS="-I/openssl-1.0.2j/install/lib/include -I/zlib-1.2.8 -I/libevent-2.1.11-stable/install/include/"

	./configure --host=x86_64-w64-mingw32 --prefix="$HOME/tor/install" --with-libevent-dir="/libevent-2.1.11-stable/install/" --with-openssl-dir="/openssl-1.0.2j/install" --with-zlib-dir="/zlib-1.2.11"

    #--enable-static-tor
    make
    make install
    cd..
    
