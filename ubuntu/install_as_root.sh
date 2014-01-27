#!/bin/bash
LOGDIR=logs

if [ ! "$USER" == "root" ] ; then
	echo "ERROR: script should be run as root - sudo $0"
	exit -1
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
apt-get -y install autoconf automake build-essential git pkg-config texi2html zlib1g-dev
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
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar xzvf yasm-1.2.0.tar.gz
rm yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
make distclean
) 2>&1 > $LOGFILE
. ~/.profile

