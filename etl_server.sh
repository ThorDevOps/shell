#!/bin/bash

# *************************************************************************** 
# * 
# * @file:etl_server.sh 
# * @author:chris 
# * @date:2018-07-10 10:30 
# * @version 1.0  
# * @scripttype: Shell Script 
# * @description: Script doing description 
# * 
# *************************************************************************** 

#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#提取当前目录是那个服，结果为纯数字
temp=`pwd |awk -F'/' '{print $3}' |tr -cd "[0-9]"`
#提取当前目录，用于后面挂载
temp2=`pwd |awk -F 'etl' '{print $2}'`
start ()
{
    PID1=`ps aux |grep -v grep |grep etl.jar|grep $temp | awk '{print $2}'`
    
    if [ "$PID1" != "" ];then
        echo -e "\e[33m  ${temp}_etl.jar  is running,PID is '${PID1}'  \e[0m"
    else
        chmod +x ${temp}_etl.jar
        folder="/game/dts${temp2}/logdata/archive/"
        if [ ! -d "$folder" ]; then
            mkdir -p "$folder"
        fi
        
        folder2="/game/etl${temp2}/logdata"
        if [ ! -d "$folder2" ]; then
            mkdir "$folder2"
        fi

        mount --bind  "$folder"  "$folder2"
        nohup /game/jdk/bin/java -server -Dfile.encoding=UTF-8 -Xmx4096m  -XX:PermSize=512M -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -jar ${temp}_etl.jar &
        
        PID2=`ps aux |grep -v grep |grep etl.jar|grep $temp | awk '{print $2}'`
        if [ "$PID2" != "" ];then
            echo -e "\e[32m  ${temp}_etl.jar start SUCCESS,PID is '${PID2}'  \e[0m"
        else
            echo -e "\e[31m  ${temp}etl.jar start FAILED  \e[0m"
        fi
    fi
}

stop ()
{
    PID1=`ps aux |grep -v grep |grep etl.jar|grep $temp | awk '{print $2}'`
    if [ "$PID1" != "" ];then
        echo -e "\e[33m ${temp}_etl.jar is Running,pid is '${PID1}',Shutting down etl...... \e[0m"
        kill ${PID1}
        sleep 2s
            PID2=`ps aux |grep -v grep |grep etl.jar|grep $temp | awk '{print $2}'`
            if [ "$PID2" != "" ];then
                echo -e "\e[31m ${temp}etl.jar is Running,Please showdown etl \e[0m"
                exit 1
            else
                echo -e "\e[32m ${temp}etl.jar is Shutdown \e[0m"
                umount /game/etl${temp2}/logdata
            fi
    else
        echo -e "\e[33m ${temp}_etl.jar is no run \e[0m"
    fi
}

restart ()
{
    stop
    start
}

status ()
{
    PID1=`ps aux |grep -v grep |grep etl.jar|grep $temp | awk '{print $2}'`
    if [ "$PID1" != "" ];then
        echo -e "\e[33m ${temp}_etl.jar is Running, pid is '${PID1}' \e[0m"
    else
        echo -e "\e[33m ${temp}_etl.jar is no run \e[0m"
    fi
}
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
esac



exit 0

