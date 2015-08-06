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
	printf "downloading rave..."
	wget -q http://www.hepforge.org/archive/rave/$RAVE_TGZ
	echo "done"
	tar xzf $RAVE_TGZ
    )
fi

# patch cout statement in rave
(
    cd $BUILD
    echo "patching rave"
    patch -p0 <<EOF
--- rave-0.6.24/src/RecoVertex/VertexTools/src/SequentialVertexFitter.cc	2015-07-03 09:10:55.075177887 +0000
+++ rave-patched/src/RecoVertex/VertexTools/src/SequentialVertexFitter.cc	2015-08-06 08:28:47.053053002 +0000
@@ -149,7 +149,7 @@
 			       const BeamSpot& beamSpot) const
 {
   VertexState beamSpotState(beamSpot);
-  cout << "sigma(yy) [mu]=" << 10000.*sqrt ( beamSpotState.error().cyy() ) << endl;
+  //  cout << "sigma(yy) [mu]=" << 10000.*sqrt ( beamSpotState.error().cyy() ) << endl;
   vector<RefCountedVertexTrack> vtContainer;
 
   if (tracks.size() > 1) {
EOF
)

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
