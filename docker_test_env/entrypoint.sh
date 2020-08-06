#!/bin/bash
set -e

git clone https://github.com/DataDog/chef-datadog.git
cd chef-datadog
bundle update --bundler
if [ -t 0 ] ; then
    echo "(starting interactive shell)"
else
    echo "(starting non interactive shell)"
    tail -f /dev/null
fi
