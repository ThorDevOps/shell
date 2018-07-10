#!/bin/bash

DATE=`date +%F`
TIME=`date +%Y%m%d-%H%M%S`


#clean 
rm -rf /root/dts/*
#cp file
mv /home/junwei/dts/* /root/dts/
chown -R root:root /root/dts

ls -al /root/dts/

#fengfa
for i in `cat game_list.txt`
do
    #backup
    mkdir -p /backup/gamebk/${DATE}/${TIME}/dts${i}
    cd /game/dts${i}/
    temp=`pwd |awk -F'/' '{print $3}'|tr -cd "[0-9]"`
    mv  /game/dts${i}/${temp}_ServerLanucher.jar /backup/gamebk/${DATE}/${TIME}/dts${i}/
    mv  /game/dts${i}/config /backup/gamebk/${DATE}/${TIME}/dts${i}/
    mv  /game/dts${i}/nohup.out /backup/gamebk/${DATE}/${TIME}/dts${i}/

    #update
    /usr/bin/rsync -azp /root/dts/config /game/dts${i}/
    /usr/bin/rsync -azp /root/dts/ServerLanucher.jar /game/dts${i}/${temp}_ServerLanucher.jar
    #/usr/bin/rsync -avzp /root/dts/log.xml /game/dts${i}/
done

