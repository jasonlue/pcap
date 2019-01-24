#!/bin/bash
#run trex.sh on trex VM to generate traffic for this script to capture.
#need root previllege to run this script. sudo ./pcap-gen.sh
iface=enp0s8
pcap=(1K 10K 100K 1M 10M 100M)
size=(1000 10000 100000 1000000 10000000 100000000)
for i in ${!pcap[@]}; do   
    if [ ! -s ${pcap[i]}.pcap ]; then 
        echo "tcpdump -w ${pcap[i]}.pcap   -i $iface -c ${size[i]} "
        tcpdump -w ${pcap[i]}.pcap  -i $iface -c ${size[i]} 
    fi
done
