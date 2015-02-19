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

echo $SRC;

BASE='/usr/local'

# Here follows paths for installation binaries and general settings
PREFIX="$BASE" # will install binaries in ~/php/bin directory, make sure it is exported in your $PATH for executables
SBIN_DIR="$BASE" # all binaries will go to ~/php/bin
CONF_DIR="$BASE/lib/php" # will use php.ini located here as ~/php/php.ini
CONFD_DIR="$BASE/lib/php/conf.d" # will load all extra configuration files from ~/php/conf.d directory
MAN_DIR="$BASE/share/man" # man pages goes here

EXTENSION_DIR="$BASE/php/share/modules" # all shared modules will be installed in ~/php/share/modules phpize binary will configure it accordingly
export EXTENSION_DIR
PEAR_INSTALLDIR="$BASE/php/share/pear" # pear package directory
export PEAR_INSTALLDIR

if [ ! -d "$CONFD_DIR" ]; then
    mkdir -p $CONFD_DIR
fi

# here follows a main configuration script
PHP_CONF="--config-cache \
    --prefix=$PREFIX \
    --sbindir=$SBIN_DIR \
    --sysconfdir=$CONF_DIR \
    --localstatedir=/var \
    --with-layout=GNU \
    --with-config-file-path=$CONF_DIR \
    --with-config-file-scan-dir=$CONFD_DIR \
    --disable-rpath \
    --mandir=$MAN_DIR \
"

# enter source directory
cd $SRC

make clean

# build configure, not included in git versions
if [ ! -f "$SRC/configure" ]; then
    ./buildconf --force
fi

# Additionally you can add these, if they are needed:
#   --enable-ftp
#   --enable-exif
#   --enable-calendar
#   --with-snmp=/usr
#   --with-pspell
#   --with-tidy=/usr
#   --with-xmlrpc
#   --with-xsl=/usr
# and any other, run "./configure --help" inside php sources


# CLI, php-fpm and apache2 module
./configure $PHP_CONF \
    --disable-cgi \
    --with-readline \
    --enable-pcntl \
    --enable-cli \
    --with-apxs2=/usr/bin/apxs2 \
    --with-pear \
    $EXT_CONF

# CGI and FastCGI
#./configure $PHP_CONF --disable-cli --enable-cgi $EXT_CONF

# build sources
make
