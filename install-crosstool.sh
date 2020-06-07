# Installation dependencies for crosstool-ng:
sudo apt-get install build-essential libncurses5-dev libtool-bin
sudo apt-get install automake libtool bison flex texinfo
sudo apt-get install gawk curl subversion git help2man

# Install crosstool-ng:
git clone https://github.com/crosstool-ng/crosstool-ng
cd crosstool-ng
./bootstrap
./configure --prefix="/home/fugitivus/git/crosstool-ng/install"
make
make install
export PATH="${PATH}:/home/fugitivus/git/crosstool-ng/install/bin"
mkdir workdir
cd workdir

# Configure crosscompiler toolchain:
#ct-ng list-samples
#ct-ng <sample-name>
#ct-ng menuconfig

# Build crosscompiler toolchain:
#ct-ng build

# Use crosscompiler toolchain:
#export PATH="${PATH}:/home/fugitivus/x-tools/arm-unknown-linux-gnueabi/bin"
#export PATH="${PATH}:/home/fugitivus/x-tools/mips-unknown-linux-uclibc/bin"
# https://crosstool-ng.github.io/docs/toolchain-usage/

