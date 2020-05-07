    # written on a cold November day 2016
    # these instructions are for x86 computers, for x64 you know what to do :)
    # install msys2 from http://msys2.github.io/
    # after installation, open msys2 console and install some useful packages (msys2.exe)
    # visit wiki pages of msys2 for further information

    pacman -Syuu
    pacman -S libgcrypt-devel --noconfirm
    pacman -S libevent-devel --noconfirm
    pacman -S msys/make msys/perl msys/tar --noconfirm
    pacman -S mingw32/mingw-w64-i686-binutils msys/binutils --noconfirm
    pacman -S mingw32/mingw-w64-i686-gcc --noconfirm
    pacman -S mingw32/mingw-w64-i686-make --noconfirm
    pacman -S msys/pkg-config mingw32/mingw-w64-i686-pkg-config --noconfirm
     
    # change console to mingw32 console (mingw32.exe)
    # download required libraries for build process (openssl,zlib,libevent)
    # Currently I cannot compile tor with openssl version greater than 1.0.2j
    wget https://www.openssl.org/source/openssl-1.0.2j.tar.gz
    wget http://zlib.net/zlib-1.2.11.tar.gz
    wget https://github.com/libevent/libevent/releases/download/release-2.1.11-stable/libevent-2.1.11-stable.tar.gz



    wget https://www.torproject.org/dist/tor-0.4.2.7.tar.gz
    mkdir openssl && mkdir libevent && mkdir zlib && mkdir tor
    tar xzf openssl-1.0.2j.tar.gz -C openssl
    tar xzf zlib-1.2.11.tar.gz -C zlib
    tar xzf libevent-2.1.11-stable.tar.gz -C libevent
    tar xzf tor-0.4.2.7.tar.gz -C tor
     
    # you may set these environment variables for compiling zlib
    export INCLUDE_PATH="/mingw32/include:/mingw32/i686-w64-mingw32/include:$INCLUDE_PATH"
    export LIBRARY_PATH="/mingw32/lib:/mingw32/i686-w64-mingw32/lib:$LIBRARY_PATH"
    export BINARY_PATH="/mingw32/bin:/mingw32/i686-w64-mingw32/bin:$BINARY_PATH"
     
    # compile zlib
    cd ~/zlib/zlib-1.2.11
    make -fwin32/Makefile.gcc
     
    # compile libevent
    cd ~/libevent/libevent-2.1.11-stable
    ./configure --prefix="$HOME/libevent/install" --enable-static --disable-shared
    make
    make install
     
    # compile openssl (if you don't have a fast computer, this may take a long time)
    # -static-libgcc flag may be redundant with -static but just in case.
    cd ~/openssl/openssl-1.0.2j
    LDFLAGS="-static -static-libgcc" ./Configure no-shared no-zlib no-asm --prefix="$HOME/openssl/install" -static mingw
    make depend && make && make install


    # now it is time to compile tor if everything is OK above
    cd ~/tor/tor-0.4.2.7/
     
    export LDFLAGS="-static -static-libgcc -L$HOME/openssl/install/lib -L$HOME/libevent/install/lib -L$HOME/zlib/zlib-1.2.11 -L/mingw32/lib -L/mingw32/i686-w64-mingw32/lib"
    export CFLAGS="-I$HOME/openssl/install/include -I$HOME/zlib/zlib-1.2.11 -I$HOME/libevent/install/include"
    export LIBRARY_PATH="$HOME/openssl/install/lib:$HOME/libevent/install/lib:$HOME/zlib/zlib-1.2.11:/mingw32/lib:/mingw32/i686-w64-mingw32/lib"
    export INCLUDE_PATH="$HOME/openssl/install/include:$HOME/zlib/zlib-1.2.11:$HOME/libevent/install/include:/mingw32/include:/mingw32/i686-w64-mingw32/include"
    export BINARY_PATH="/mingw32/bin:/mingw32/i686-w64-mingw32/bin"
    export PKG_CONFIG_PATH="$HOME/openssl/install/lib/pkgconfig:$PKG_CONFIG_PATH"
     
    # this is important if -lcrypt32 is omitted, you may get linker error
    export LIBS="-lcrypt32"
     
    ./configure --disable-gcc-hardening --enable-static-tor --prefix="$HOME/tor/install" --with-libevent-dir="$HOME/libevent/install/lib" --with-openssl-dir="$HOME/openssl/install/lib" --with-zlib-dir="$HOME/zlib/zlib-1.2.11"
    make
    make install
     
    # The configuration parameter "--disable-gcc-hardening" builds Tor without requiring
    # the libssp-0.dll. If you build without this parameter then don't forget to copy
    # libssp-0.dll from /mingw32/bin to the folder where tor.exe is located. libssp is
    # a library for stack protection.
