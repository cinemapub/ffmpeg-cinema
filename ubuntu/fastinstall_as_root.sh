#!/bin/bash
LOGDIR=logs
BASEDIR=$(pwd)

if [ ! "$USER" == "root" ] ; then
	echo "ERROR: script should be run as root - sudo $0"
	exit -1
fi

if [ ! -d $LOGDIR ] ; then
	mkdir $LOGDIR
fi
STEP=0

echo "--- APT: Update APT"
STEP=$( expr $STEP + 1 )
DESC=apt-update
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
apt-get update
) 2>&1 > $LOGFILE

echo "--- APT: install compilation aids"
STEP=$( expr $STEP + 1 )
DESC=apt-compile
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
apt-get -y install autoconf automake build-essential git pkg-config texi2html zlib1g-dev xmlto
) 2>&1 > $LOGFILE

echo "--- APT: install A/V libraries"
STEP=$( expr $STEP + 1 )
DESC=apt-libs
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
apt-get -y install libass-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev libxext-dev libxfixes-dev
) 2>&1 > $LOGFILE

echo "--- APT: install yasm/x264/lame"
STEP=$( expr $STEP + 1 )
DESC=
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
apt-get install yasm libx264-dev x264 libmp3lame-dev lame libvpx-dev
# files in:
#   /usr/lib/x86_64-linux-gnu/libx264.a
#   /usr/lib/x86_64-linux-gnu/pkgconfig/x264.pc
#   /usr/lib/x86_64-linux-gnu/libmp3lame.a
#   /usr/lib/x86_64-linux-gnu/libvpx.a
#   /usr/lib/pkgconfig/vpx.pc

) 2>&1 > $LOGFILE

echo "--- INSTALL FFMPEG"
STEP=$( expr $STEP + 1 )
DESC=yasm
LOGFILE=$LOGDIR/log.$STEP.$DESC.txt
echo "  - log file in $LOGFILE "
(
git clone git://source.ffmpeg.org/ffmpeg
pushd ffmpeg
PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$BASEDIR" \
	--extra-cflags"-I/usr/lib/x86_64-linux-gnu" \
	--extra-ldflags="-L/usr/lib/x86_64-linux-gnu" \
	--extra-libs="-ldl" --enable-gpl \
	--enable-libmp3lame --enable-libtheora --enable-libvpx \
	--enable-libx264 --enable-nonfree --enable-x11grab

) 2>&1 > $LOGFILE

