#!/bin/bash
LOGDIR=logs
BASEDIR=$(dirname $0)
BINDIR=$BASEDIR/bin

if [ ! "$USER" == "root" ] ; then
	echo "ERROR: script should be run as root - sudo $0"
	exit -1
fi

if [ ! -d $BINDIR ] ; then
	mkdir $BINDIR
fi
if [ ! -d $LOGDIR ] ; then
	mkdir $LOGDIR
fi
STEP=0

echo "APT: Update APT"
STEP=$( expr $STEP + 1 )
DESC=apt-update
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
apt-get update
) 2>&1 > $LOGFILE

echo "APT: install compilation aids"
STEP=$( expr $STEP + 1 )
DESC=apt-compile
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
apt-get -y install autoconf automake build-essential git pkg-config texi2html zlib1g-dev xmlto
) 2>&1 > $LOGFILE

echo "APT: install A/V libraries"
STEP=$( expr $STEP + 1 )
DESC=apt-libs
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
apt-get -y install libass-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev
) 2>&1 > $LOGFILE

echo "INSTALL: yasm"
STEP=$( expr $STEP + 1 )
DESC=yasm
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
wget -q http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzvf yasm-1.2.0.tar.gz
rm yasm-1.2.0.tar.gz
pushd yasm-1.2.0
./configure --prefix="$BASEDIR" --bindir="$BINDIR"
make
make install
make distclean
popd
) 2>&1 > $LOGFILE
. ~/.profile

echo "INSTALL: x264"
STEP=$( expr $STEP + 1 )
DESC=git-x264
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
## git clone --depth 1 git://git.videolan.org/x264.git
git clone http://git.videolan.org/git/x264.git x264
pushd x264
./configure --prefix="$BASEDIR" --bindir="$BINDIR" --enable-static
make
make install
make distclean
popd
) 2>&1 > $LOGFILE


