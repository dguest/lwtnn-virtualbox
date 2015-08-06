#!/usr/bin/env bash

set -eu

sudo apt-get install -y libclhep-dev
sudo apt-get install -y pkg-config

BUILD=rave-build
RAVE_FILE=rave-0.6.24
RAVE_TGZ=${RAVE_FILE}.tar.gz
mkdir -p $BUILD
if [[ ! -d $BUILD/$RAVE_FILE ]] ; then
    (
	cd $BUILD
	echo -n "downloading rave..."
	wget -q http://www.hepforge.org/archive/rave/$RAVE_TGZ
	echo "done"
	tar xzf $RAVE_TGZ
    )
fi

# now build rave
(
    cd $BUILD/${RAVE_FILE%.tar.gz}
    ./configure --disable-java
    make -j 4
    make install
    ldconfig
)

# weird hack (some headers request a path that doesn't exist...)
(
    cd $(pkg-config rave --variable=prefix)/include/rave/impl/RaveBase
    if [[ ! -f RaveInterface/rave/Charge.h ]] ; then
	echo "HACKING in rave interface link!" >&2
	ln -s ../../../ RaveInterface
    fi
)
