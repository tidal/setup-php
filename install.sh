#!/bin/bash
dir="$( cd "$( dirname "$0" )" && pwd )" 
source $dir/config.sh 

echo "*******************************"
echo "* installing php version $phpVersion"
echo "*******************************"

cd $phpLibDir

# requires a php source directory as a first argument
if [ ! -d "$phpArchiveDir" ]
then
    echo "Php source is not a valid directory : $phpArchiveDir"
    exit 1
fi

# Ubuntu users only, a quirk to locate libpcre
if [ ! -f "/usr/lib/libpcre.a" ]; then
    if [ -f "/usr/lib/i386-linux-gnu/libpcre.a" ]; then
        sudo ln -s /usr/lib/i386-linux-gnu/libpcre.a /usr/lib/libpcre.a
    elif [ -f "/usr/lib/x86_64-linux-gnu/libpcre.a" ]; then
        sudo ln -s /usr/lib/x86_64-linux-gnu/libpcre.a /usr/lib/libpcre.a
    fi
fi

# define full path to php sources
SRC="$phpLibDir/$phpArchiveDir"

cd $SRC;

# make install
make install

# make sure apache is running in threaded mode
# (for some reason apache packages sometimes seem to ship
# with workwr or event mpm activated) 
a2dismod mpm_event
a2dismod mpm_worker
a2enmod mpm_prefork
# activate php
a2enmod php5

# restart apache
/etc/init.d/apache2 restart -f
