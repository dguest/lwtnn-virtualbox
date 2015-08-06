#!/usr/bin/env bash

set -eu

if [[ -d delphes ]] ; then
    rm -rf delphes
fi
git clone git@github.com:dguest/delphes-realistic-tracking.git delphes
(
    cd delphes
    ./configure
    make -j 4
    ln -s ~/data Parametrisation
)
