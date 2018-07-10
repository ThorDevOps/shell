#!/bin/bash
#
#***************************************************************************
# * 
# * @file:auto_mysql.sh 
# * @author:luo_junwei
# * @date:2018-04-16 
# * @version 1.0
# * @description: scripts for mysql server install
# * 
#***************************************************************************
#

Download_Dir=/usr/local/src
Mysql_Stable_Ver=mysql-5.6.36-linux-glibc2.5-x86_64
Mysql_Dir=/game/mysql
Mysql_env=/etc/profile.d/mysqld.sh

#check for root user
if [ "$(id -u)" -ne 0 ]; then
	echo -e "\033[31m You must run this script as root. Sorry! \033[0m"
        exit 1
fi

#add mysql group and user
id mysql
if [ $? -ne 0 ];then
	groupadd mysql
	useradd -s /sbin/nologin -g mysql -M mysql
fi
#add depend
yum install -y perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib perl-DBD-MySQL perl-DBI perl-Data-Dumper perl-IO-Compress perl-Net-Daemon perl-PlRPC libaio

#download
cd ${Download_Dir}
    wget -O ${Mysql_Stable_Ver}.tar.gz http://download.zl.6zlgame.com/mysql/${Mysql_Stable_Ver}.tar.gz
    tar zxf ${Mysql_Stable_Ver}.tar.gz

if [ -d /game ]; then
    mv ${Mysql_Stable_Ver} $Mysql_Dir
	chown -R mysql.mysql $Mysql_Dir
else
    mkdir /game
    mv ${Mysql_Stable_Ver} $Mysql_Dir
	chown -R mysql.mysql $Mysql_Dir
fi

mkdir -p /data/mysql/data
chown -R mysql.mysql /data/mysql/data


#change config
cp /etc/my.cnf /etc/my.cnf_bak
    
    cat > /etc/my.cnf<<EOF
[client]
port=3306
socket=/tmp/mysql.sock
#socket=/data/mysql/mysql.sock
default_character_set= utf8

[mysqld]
user=mysql
port=3306
datadir=/data/mysql
basedir=/game/mysql

#socket=/data/mysql/mysql.sock
log-error=/data/mysql/mysqld.log
pid-file=/data/mysql/mysql.pid
character_set_server=utf8
init_connect='SET NAMES utf8'

default_storage_engine = InnoDB
default-tmp-storage-engine = InnoDB
innodb_open_files = 500
innodb_buffer_pool_size = 512M
innodb_log_buffer_size = 16M
max_allowed_packet = 2048M

skip-external-locking
skip-name-resolve


key_buffer_size = 384M
join_buffer_size = 8M
table_open_cache = 512
sort_buffer_size = 2M
net_buffer_length = 16K
read_buffer_size = 2M
read_rnd_buffer_size = 8M
thread_cache_size = 12
query_cache_size = 32M
query_cache_limit = 2M  

max_connections = 10000
max_connect_errors = 100
open_files_limit = 65535
concurrent_insert = 2
interactive_timeout = 28800
wait_timeout = 1000
back_log = 600


log-bin=mysql-bin
expire_logs_days = 7
server-id=1
binlog-ignore-db=information_schema
binlog-ignore-db=performance_schema
binlog-ignore-db=mysql
binlog-ignore-db=sys

log_output=file
slow_query_log=1
slow_query_log_file=/data/mysql/slow.log
long_query_time=2


[mysqldump]
quick

[mysql]
no-auto-rehash

EOF

cd ${Mysql_Dir}
./scripts/mysql_install_db --basedir=/game/mysql/ --datadir=/data/mysql/ --user=mysql
sed -i 's#/usr/local/mysql#/game/mysql#g' /game/mysql/bin/mysqld_safe

#add path
if [ -f $Mysql_env ];then
	rm -rf $Mysql_env
	touch $Mysql_env
	echo 'PATH=/game/mysql/bin/:$PATH' >> $Mysql_env
else
	touch $Mysql_env
	echo 'PATH=/game/mysql/bin/:$PATH' >> $Mysql_env
fi

#change init
cp /game/mysql/support-files/mysql.server /etc/init.d/mysqld

sed -i 's#^basedir=#basedir=/game/mysql#g' /etc/init.d/mysqld
sed -i 's#^datadir=#basedir=/data/mysql/data#g' /etc/init.d/mysqld

chmod +x /etc/init.d/mysqld
source $Mysql_env
ln -s /game/mysql/bin/mysql /usr/local/bin/mysql

#查看启动情况
/etc/init.d/mysqld start
netstat -tnlp

echo "/etc/init.d/mysqld start|stop|restart"
