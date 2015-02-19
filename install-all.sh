#!/bin/bash
dir="$( cd "$( dirname "$0" )" && pwd )"  

echo "*******************************"
echo "* installing php version $phpVersion"
echo "*******************************"

#source $dir/install-dependencies.sh
#source $dir/download.sh
#source $dir/build.sh
source $dir/install.sh
