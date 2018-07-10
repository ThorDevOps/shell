#!/bin/bash

DATE=`date +%F`
TIME=`date +%Y%m%d-%H%M%S`


#clean 
rm -rf /root/dts/*
#cp file
mv /home/junwei/dts/* /root/dts/
chown -R root:root /root/dts

ls -al /root/dts/

# rsync
for i in `cat game_list.txt`
do
    #backup
    mkdir -p /backup/gamebk/${DATE}/${TIME}/dts${i}
    mv  /game/dts${i}/config /backup/gamebk/${DATE}/${TIME}/dts${i}/

    #update
    /usr/bin/rsync -azp /root/dts/config /game/dts${i}/
done
