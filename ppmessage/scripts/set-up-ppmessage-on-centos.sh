#!/bin/bash

# version: 0.3
# maintainer: Jin He <jin.he@ppmessage.com>
# description: a shell script to deploy PPMessage on Debian and Ubuntu
#
# version: 0.3
# remove ffmpeg/nginx/mysql/scikit
#


function ppmessage_err()
{
    echo "EEEE) $1"
    echo
    exit 1
}

function ppmessage_check_path()
{
    if [ ! -f ./dist.sh  ];
    then
        ppmessage_err "you should run under the first-level path of ppmessage!"
    fi
}

function ppmessage_need_root()
{
    if [ $UID -ne 0 ];
    then
        ppmessage_err "you should run in root, or use sudo!"
    fi
}

ppmessage_need_root

function download_geolite2() 
{
    #SCRIPT=$(readlink -f "$0")
    #BASEDIR=$(dirname "${SCRIPT}")
    BASEDIR=$(dirname "$BASH_SOURCE")
    APIDIR="${BASEDIR}"/../api/geolite2
    wget --directory-prefix="${APIDIR}" -c http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
    GEOFILE=GeoLite2-City.mmdb.gz
    GEOPATH="${APIDIR}"/GeoLite2-City.mmdb.gz
    
    echo "${GEOPATH}"
    echo $(readlink -e "${GEOPATH}")
    AGEOPATH=$(readlink -e "${GEOPATH}")
    STEM=$(basename "${GEOFILE}" .gz)
    gunzip -c "${AGEOPATH}" > "${APIDIR}"/"${STEM}"
}
    
download_geolite2

#yum update

# for debian
yum install -y \
    libjpeg-turbo-devel \
    epel-release \
    sudo \
    autoconf \
    automake \
    gcc \
    git \
    gcc-c++ \
    libgfortran \
    blas-devel \
    lapack-devel \
    atlas-devel \
    libffi-devel \
    freetype-devel \
    libmagic1 \
    libmp3lame-dev \
    ncurses-devel \
    libopencore-amrwb-dev \
    libopencore-amrnb-dev \
    opus-devel \
    libpng-devel \
    pcre \
    pcre-devel \
    sslh \
    libtool \
    mercurial \
    openssl \
    pkgconfig \    
    redis \
    wget 

version=$(cat /etc/issue)
[[ $version = CentOS* ]] && echo $version || echo "not CentOS, end" exit
[[ $version = *' 6.'* ]] && manual_python=1 || manual_python=0
if [ $manual_python = 1 ];then
    pverion=`python -V 2>&1`

    [[ $pverion = *' 2.7.'* ]] && python_installed=1 || python_installed=0
    if [ $python_installed = 1 ];then
        echo "python installed"
    else
        # install python2.7
        cd /tmp
        wget https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz
        xz -d Python-2.7.12.tar.xz
        tar -xvf Python-2.7.12.tar
        cd Python-2.7.12
        ./configure
        make
        make install
        # install pip
        wget https://bootstrap.pypa.io/ez_setup.py
        sudo /usr/local/bin/python2.7 ez_setup.py
        sudo /usr/local/bin/easy_install-2.7 pip
        cd -
    fi
else
    yum install -y \
        python \
        python-devel \
        python-pip \
fi   

# some python modules need libmaxminddb, install it before run 'pip install ...'
cd /tmp
git clone --recursive https://github.com/maxmind/libmaxminddb
cd libmaxminddb
./bootstrap
./configure
make && make install
cd -


# "pip install -i http://pypi.douban.com/simple xxx" might be faster
pip install \
    importlib \
    StringGenerator \
    axmlparserpy \
    beautifulsoup4 \
    paramiko \
    cryptography \
    filemagic \
    geoip2 \
    identicon \
    paho-mqtt \
    pillow \
    ppmessage-mqtt \
    pypinyin \
    pyparsing \
    python-dateutil \
    python-gcm \
    python-magic \
    qrcode \
    readline \
    redis \
    supervisor \
    sqlalchemy \
    tornado \
    xlrd

pip install git+https://github.com/senko/python-video-converter.git \
    hg+https://dingguijin@bitbucket.org/dingguijin/apns-client

# to support mysql/postgresql needs more installation
# apt-get install mysql-server postgresql libpq-dev
# pip install psycopg2
echo "Finish install the requirements of PPMessage, next to run ppmessage.py to start PPMessage."
