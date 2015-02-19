#!/bin/bash
dir="$( cd "$( dirname "$0" )" && pwd )" 
source $dir/config.sh 

echo "downloading php source from $phpSourceURI"

mkdir -p $libDir
mkdir -p $phpLibDir

cd $phpLibDir

rm -f $phpArchiveFile 
rm -f -r $phpArchiveDir

#exit

wget $phpSourceURI -O - | tar zxpf -



#wget http://php.net/distributions/php-5.6.5.tar.gz
