#!/bin/bash
#
#***************************************************************************
# * 
# * @file:auto_install_jdk.sh 
# * @author:luo_junwei
# * @date:2018-04-16 
# * @version 1.0
# * @description: scripts for jdk server install
# * 
#***************************************************************************
#
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

java_env=/etc/profile.d/jdk.sh

#check for root user
if [ "$(id -u)" -ne 0 ]; then
	echo -e "\033[31m You must run this script as root. Sorry! \033[0m"
        exit 1
fi

#download jdk
wget -O /usr/local/src/jdk-8u161-linux-x64.tar.gz http://download.zl.6zlgame.com/java/jdk-8u161-linux-x64.tar.gz

#
if [ ! -d /game ]; then
    mkdir /game/
fi


tar zxf /usr/local/src/jdk-8u161-linux-x64.tar.gz -C /game/
mv /game/jdk1.8.0_161 /game/jdk

#add path
if [ -f $java_env ];then
	rm -rf $java_env
	touch $java_env
        echo 'export JAVA_HOME=/game/jdk' >> $java_env
        echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> $java_env
        echo 'export PATH=$PATH:$JAVA_HOME/bin' >> $java_env

else
	touch $java_env
	echo 'export JAVA_HOME=/game/jdk' >> $java_env
	echo 'export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar' >> $java_env
	echo 'export PATH=$PATH:$JAVA_HOME/bin' >> $java_env
fi
source $java_env

#cheack path
java -version
