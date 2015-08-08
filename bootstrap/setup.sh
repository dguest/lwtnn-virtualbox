#!/usr/bin/env bash
set -eu

## clone some things
# start with my bash environment
if [[ -d setup ]] ; then
    rm -r setup
fi
git clone https://github.com/dguest/setup.git
cat <<EOF > ~vagrant/.bashrc
SETUP=~/setup
. \${SETUP}/work_env.sh
. \${SETUP}/bash_tools_common.sh
EOF
