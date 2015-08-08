#!/usr/bin/env bash
set -eu

if [[ ! -d delphes ]] ; then
    git clone git@github.com:dguest/delphes-realistic-tracking.git delphes
fi
(
    cd delphes
    ./configure
    make -j 4
    ln -s ~/data Parametrisation
)

# get plotting package
if [[ -d delphes-plotting ]] ; then
    rm -rf delphes-plotting
fi
if type ndhist-config &> /dev/null ; then
    git clone git@github.com:dguest/delphes-plotting.git
    (
	cd delphes-plotting
	ln -s ../delphes
	make -j 4
    )
fi
