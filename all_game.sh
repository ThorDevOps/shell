#!/bin/bash

# *************************************************************************** 
# * 
# * @file:game.sh 
# * @author:Luo_junwei@163.com 
# * @date:2018-06-26 22:17 
# * @version 1.0  
# * @scripttype: Shell Script 
# * @description: Script doing description 
# * 此脚本主要用对游戏服进行批量操作，可以起停，重启，备份 
# *************************************************************************** 

DATE=`date +%F`
TIME=`date +%F_%H%M%S`

stop ()
{
	for temp in `cat /root/game_list.txt |awk -F "a" '{print $1}'` 
	do
		PID1=`ps aux |grep -v grep |grep ServerLanucher.jar|grep $temp | awk '{print $2}'`
	if [ "$PID1" != "" ];then
		echo -e "\e[33m game ${temp} is Running,pid is '${PID1}',Shutting down ${temp}...... \e[0m"
		kill ${PID1}
	else
		echo -e "\e[33m game ${temp} is no run \e[0m"
	fi
	done
	sleep 1m
	
	for temp in `cat /root/game_list.txt |awk -F "a" '{print $1}'` 
	do
		PID2=`ps aux |grep -v grep |grep ServerLanucher.jar|grep $temp | awk '{print $2}'`
	if [ "$PID2" != "" ];then
		echo -e "\e[31m game ${temp} is Running,Please showdown ${temp} \e[0m"
		exit 1
	else
		echo -e "\e[32m game ${temp} is Shutdown \e[0m"
	fi
	done
}

start ()
{
	for temp in `cat /root/game_list.txt` 
	do
		cd /game/dts${temp}/
		/bin/sh game.sh start
	done
}

restart ()
{
    stop
    start
}

status ()
{
	for temp in `cat /root/game_list.txt` 
	do
		cd /game/dts${temp}/
		/bin/sh game.sh status
	done
}

backup ()
{
    for temp in `cat /root/game_list.txt`
	do
		mkdir -p /backup/gamebk/${DATE}/${TIME}/dts${temp}
        cd /game/dts${temp}/
        i=`pwd |awk -F'/' '{print $3}' |tr -cd "[0-9]"`
        mv /game/dts${temp}/${i}_ServerLanucher.jar /backup/gamebk/${DATE}/${TIME}/dts${temp}/
		mv /game/dts${temp}/config /backup/gamebk/${DATE}/${TIME}/dts${temp}/
		mv /game/dts${temp}/nohup.out /backup/gamebk/${DATE}/${TIME}/dts${temp}/
	done
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
	backup)
		backup
		;;
	*)
		echo $"Usage: $0 {start|stop|restart|status|backup}"
esac


exit 0


