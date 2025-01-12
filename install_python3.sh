/bin/bash
#***********
#author:songxiaomin
#date:2025-01-11
#***********

PYTHON_VERSION=3.9.7
END=tgz
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel
wget https://www.python.org/ftp/python/3.9.7/Python-${PYTHON_VERSION}.${END}   -P  /usr/local/src
cd /usr/local/src
tar -zxvf Python-${PYTHON_VERSION}.${END}
cd Python-${PYTHON_VERSION}
./configure --prefix=/usr/local/python3
make && make install
ln -s /usr/local/python3/bin/python3.9 /usr/bin/python3
ln -s /usr/local/python3/bin/pip3.9 /usr/bin/pip3








