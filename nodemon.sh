#!/bin/bash
# Eswede nodemon 1.1 - anodos Masternode Monitoring
#If you find this script helpful
#BTC to **3H1JNkydHxDbhoXLREpxXccvyNh7Awr2jX**


#Processing command line params
if [ -z $1 ]; then dly=1; else dly=$1; fi   # Default refresh time is 1 sec

datadir="/$USER/.anodoscore$2"   # Default datadir is /root/.anodoscore
 
# Install jq if it's not present
dpkg -s jq 2>/dev/null >/dev/null || sudo apt-get -y install jq

#It is a one-liner script for now
watch -ptn $dly "echo '===========================================================================
Outbound connections to other anodos nodes [anodos datadir: $datadir]
===========================================================================
Node IP               Ping    Rx/Tx     Since  Hdrs   Height  Time   Ban
Address               (ms)   (KBytes)   Block  Syncd  Blocks  (min)  Score
==========================================================================='
anodos-cli -datadir=$datadir getpeerinfo | jq -r '.[] | select(.inbound==false) | \"\(.addr),\(.pingtime*1000|floor) ,\
\(.bytesrecv/1024|floor)/\(.bytessent/1024|floor),\(.startingheight) ,\(.synced_headers) ,\(.synced_blocks)  ,\
\((now-.conntime)/60|floor) ,\(.banscore)\"' | column -t -s ',' && 
echo '==========================================================================='
uptime
echo '==========================================================================='
echo 'Masternode Status: \n# anodos-cli masternode status' && anodos-cli -datadir=$datadir masternode status
echo '==========================================================================='
echo 'Sync Status: \n# anodos-cli mnsync status' &&  anodos-cli -datadir=$datadir mnsync status
echo '==========================================================================='
echo 'Masternode Information: \n# anodos-cli getinfo' && anodos-cli -datadir=$datadir getinfo
echo '==========================================================================='
echo 'Usage: nodemon.sh [refresh delay] [datadir index]'
echo 'Example: nodemon.sh 10 22 will run every 10 seconds and query anodosd in /$USER/.anodoscore22'
echo '\n\nPress Ctrl-C to Exit...'"