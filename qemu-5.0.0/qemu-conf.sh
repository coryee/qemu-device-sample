#!/bin/bash
set -e

SRCDIR=$(pwd)
BUILDDIR=$SRCDIR/local-build
RPMBUILD_DIR=/builddir/build/
VERSION=$(cat VERSION)


function build_raw {
../configure \
  --cc=gcc \
  --disable-glusterfs \
  --enable-guest-agent \
  --enable-numa \
  --enable-rbd \
  --enable-spice \
  --enable-smartcard \
  --enable-opengl \
  --enable-usb-redir \
  --enable-avx2 \
  --target-list=x86_64-softmmu \
  --audio-drv-list= \
  --enable-cap-ng \
  --enable-coroutine-pool \
  --enable-curl \
  --enable-kvm \
  --enable-libiscsi \
  --enable-libusb \
  --enable-linux-aio \
  --enable-lzo \
  --enable-pie \
  --disable-strip \
  --enable-tpm \
  --enable-trace-backend=log \
  --enable-vnc-sasl \
  --disable-werror \
  --disable-xen \
  --disable-nettle \
  --disable-bsd-user \
  --enable-debug \
  --enable-debug-info \
  --disable-linux-user \
  --disable-user \
  --enable-vnc \
  --enable-tcg \
  --enable-capstone 
    [ $? -eq 0 ] && make -j 8

    exit 0
}

function check_config
{

    local var=$( pip3 list --format=freeze 2>/dev/null| grep "Sphinx" | awk -F '==' '{print $2}' )

    if [[ $var < "3.0.0" ]] ;then
        echo "warn: pip3 install Sphinx ,now need high version";
	exit 1
    fi
}

function q_help
{

    echo "no arg, make rpm from git src"
    echo "-b   make rpm from src rpm package, for arm64"
    echo "-d   run config and make"
}

function main {

    local var=""
    while getopts "hb:d" arg; do
        case $arg in
            h)
                q_help
                exit 0
                ;;
            b)
                echo "make rpm from src rpm package"
                MODE=3
		var=$OPTARG
                ;;
            d)
                echo "make debug"
                MODE=2
                ;;
            ?)
                echo "invalid argument: $arg"
		q_help
                exit 2
                ;;
        esac
    done

    check_config
    build_raw

    echo "invalid MODE: $MODE"
    exit 2
}

### main ###
[ -d $BUILDDIR ] && rm -rf $BUILDDIR

mkdir $BUILDDIR

pushd $BUILDDIR
main $@

popd

