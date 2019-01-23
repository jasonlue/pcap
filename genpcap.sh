#!/bin/bash
#run trex.sh on trex VM to generate traffic for this script to capture.

tcpdump -w 1K.pcap   -c 1000 &
tcpdump -w 10K.pcap  -c 10000 &
tcpdump -w 100K.pcap -c 100000 &
tcpdump -w 1M.pcap   -c 1000000 &
tcpdump -w 10M.pcap  -c 10000000 &
tcpdump -w 100M.pcap -c 100000000