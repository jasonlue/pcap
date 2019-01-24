#!/bin/bash

function help()
{
    echo "$0 [1K|10K|100K|1M|10M|100M] [prof|massif|run]"
    exit 1
}
 
if (($# != 2)); then
    echo missing parameters.
    help
fi

case $2 in
    prof)
        cmd="HEAPPROFILE=hp ";;
    massif)
        cmd="valgrind --tool=massif ";;
    run)
        cmd="";;
    *)
        help;;
esac

cmd+="bro -Qr ~/pcap/$1.pcap site/local.bro misc/loaded-scripts misc/profiling policy/protocols/smb > o.log 2>&1"
rm -rf bro-$1-$2
mkdir bro-$1-$2
pushd bro-$1-$2
echo "Running $cmd"
#$cmd interprets special characters incorrectly. eval avoid it.
eval $cmd
popd
