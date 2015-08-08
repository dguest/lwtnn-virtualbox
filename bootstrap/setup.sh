#!/usr/bin/env bash
set -eu

## clone some things
# start with my bash environment
if [[ -d setup ]] ; then
    rm -r setup
fi
git clone git@github.com:dguest/setup.git
git clone git@github.com:dguest/random-tools.git
cat <<EOF > ~vagrant/.bashrc
SETUP=~/setup
. \${SETUP}/ubox_setup.sh
EOF
