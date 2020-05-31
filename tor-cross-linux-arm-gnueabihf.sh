# Tor Static Cross compile From Linux64 to Linux-ARM-64Bit
# Tested on Debian 10 (Buster) 64bit


# Install Cross-Compiler-Environment:
    apt-get update && apt-get upgrade -y
    apt-get install -y build-essential wget gcc libcrypto++-dev
    apt-get install -y gcc-multilib binutils gobjc++ libtool
    apt-get install -y make autoconf pkg-config gawk
    apt-get install -y gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf
        
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
	cd zlib-1.2.11
    export CC="arm-linux-gnueabihf-gcc" 
    ./configure --prefix="/libevent-2.1.11-stable/install" 
    make BINARY_PATH=$PREFIXDIR/bin INCLUDE_PATH=$PREFIXDIR/include LIBRARY_PATH=$PREFIXDIR/lib SHARED_MODE=1 install
	cd ..
    
# Build libevent:
    cd libevent-2.1.11-stable
    ./configure --prefix="/libevent-2.1.11-stable/install" --enable-static --disable-shared --host=arm-linux-gnueabihf LDFLAGS="-static"
    make
    make install
    cd ..
    
# Build openssl:
    cd /openssl-1.0.2j
    export CC="arm-linux-gnueabihf-gcc" 
    export LDFLAGS="-static -static-libgcc" 
    
    ./Configure linux-generic32 shared --prefix="/openssl-1.0.2j/install/" 
    #--cross-compile-prefix="/usr/bin/arm-linux-gnueabihf-"

    make && make install
    cd ..
	
# Build Tor:
    cd /tor-0.4.2.7
    #export CC="arm-linux-gnueabihf-gcc" 
    export LIBS="-lssl -lcrypto -lpthread -ldl"
    export LDFLAGS="-static -static-libgcc -L/usr/arm-linux-gnueabi/lib/ -L/openssl-1.0.2j/install/lib"
    export CFLAGS="-I/openssl-1.0.2j/install/lib/include -I/zlib-1.2.8 -I/libevent-2.1.11-stable/install/include/"

    ./configure --enable-static-tor --host=arm-linux-gnueabihf --prefix="$HOME/tor/install" --with-libevent-dir="/libevent-2.1.11-stable/install/" --with-openssl-dir="/openssl-1.0.2j/install/" --with-zlib-dir="/zlib-1.2.11" --disable-tool-name-check

    make
    make install
    cd ..

# cleanup:
    rm zlib-1.2.11.tar.gz
    rm libevent-2.1.11-stable.tar.gz
    rm openssl-1.0.2j.tar.gz
    rm tor-0.4.2.7.tar.gz
    rm -r /zlib-1.2.11
    rm -r /libevent-2.1.11-stable
    rm -r /openssl-1.0.2j
    rm -r /tor-0.4.2.7
