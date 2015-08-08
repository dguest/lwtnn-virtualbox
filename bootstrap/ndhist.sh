#/usr/bin/env bash
set -eu

# get ndhist
if ! type ndhist-config &> /dev/null ; then
    git clone git@github.com:dguest/ndhist.git
    (
	cd ndhist
	make -j 4
	sudo make install
    )
fi

