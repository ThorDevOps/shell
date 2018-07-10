#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

temp=`pwd |awk -F'/' '{print $3}' |tr -cd "[0-9]"`

start ()
{
    PID1=`ps aux |grep -v grep |grep ServerLanucher.jar|grep $temp | awk '{print $2}'`
    if [ "$PID1" != "" ];then
        echo -e "\e[33m game ${temp} is running,PID is '${PID1}'  \e[0m"
    else
        chmod +x ${temp}_ServerLanucher.jar
        nohup /game/jdk/bin/java -server -Dfile.encoding=UTF-8  -Xms4096m -Xmx6144m  -XX:PermSize=512M -XX:MaxPermSize=512m  -XX:+HeapDumpOnOutOfMemoryError -jar ${temp}_ServerLanucher.jar &
        PID2=`ps aux |grep -v grep |grep ServerLanucher.jar|grep $temp | awk '{print $2}'`
        if [ "$PID2" != "" ];then
            echo -e "\e[32m game  ${temp} start SUCCESS,PID is '${PID2}'  \e[0m"
        else
            echo -e "\e[31m game  ${temp} start FAILED  \e[0m"
        fi
    fi
}

stop ()
{
    PID1=`ps aux |grep -v grep |grep ServerLanucher.jar|grep $temp | awk '{print $2}'`
    if [ "$PID1" != "" ];then
        echo -e "\e[33m game ${temp} is Running,pid is '${PID1}',Shutting down ${temp}...... \e[0m"
        kill ${PID1}
        sleep 1m
            PID2=`ps aux |grep -v grep |grep ServerLanucher.jar|grep $temp | awk '{print $2}'`
            if [ "$PID2" != "" ];then
                echo -e "\e[31m game ${temp} is Running,Please showdown ${temp} \e[0m"
                exit 1
            else
                echo -e "\e[32m game ${temp} is Shutdown \e[0m"
            fi
    else
        echo -e "\e[33m game ${temp} is no run \e[0m"
    fi
}

restart ()
{
    stop
    start
}

status ()
{
    PID1=`ps aux |grep -v grep |grep ServerLanucher.jar|grep $temp | awk '{print $2}'`
    if [ "$PID1" != "" ];then
        echo -e "\e[33m game ${temp} is Running, pid is '${PID1}' \e[0m"
    else
        echo -e "\e[33m game ${temp} is no run \e[0m"
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


