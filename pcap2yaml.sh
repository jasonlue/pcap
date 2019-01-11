#!/bin/bash
#pcap2yaml.sh <pcap>.pcap
#   split <pcap> into separate flow files.
#   generate <pcap>.yaml which includes all the flows.
#   
if (( $# != 1));then
    echo missing parameters. example:
    echo "$0 <pcap file>"
fi

PCAP=$1
if [ ! -f $PCAP ]; then
    echo "$PCAP: file doesn't exist"
fi

#create fresh $PCAPD folder under current folder.
PCAPD="$PCAP.d"
echo "create a fresh directory: $PCAPD"
rm -rf $PCAPD
mkdir $PCAPD

#split pcap into different flows.
echo "Split $PCAP into seperate flows under $PCAPD"
cd $PCAPD
../pcap -s "../$PCAP"
cd ..

YAML="$PCAP.yaml"
rm -f $YAML
echo "generate $YAML"
cat > $YAML << EOL
- duration : 1
  generator :  
          distribution : "seq"
          clients_start : "16.0.0.1"
          clients_end   : "16.0.0.255"
          servers_start : "48.0.0.1"
          servers_end   : "48.0.255.255"
          dual_port_mask : "1.0.0.0" 
          tcp_aging      : 0
          udp_aging      : 0
  cap_ipg    : false
  cap_info : 
EOL

#loop through each file under $PCAPD
for f in $PCAPD/*; do
    cat >> $YAML << EOL
     - name: $f
       cps : 1
       ipg : 10000
       rtt : 10000
       w   : 1
EOL

done

