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

bro="bro -Qr ~/pcap/$1.pcap site/local.bro misc/loaded-scripts misc/profiling > o.log 2>&1"
case $2 in
    prof)
        cmd="HEAPPROFILE=bro $bro && google-pprof --callgrind /usr/local/bro/bin/bro bro.*.heap > bro.heap";;
    massif)
        cmd="valgrind --tool=massif $bro";;
    run)
        cmd=$bro;;
    *)
        help;;
esac

cmd+=

rm -rf bro-$1-$2
mkdir bro-$1-$2
pushd bro-$1-$2
echo "Running $cmd"
#$cmd interprets special characters incorrectly. eval avoid it.
time eval $cmd
popd
