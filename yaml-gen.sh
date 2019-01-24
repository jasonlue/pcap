#!/bin/bash
#pcap2yaml.sh <pcap>.pcap
#   split <pcap> into separate flow files.
#   generate <pcap>.yaml which includes all the flows.
#   
if (( $# != 1));then
    echo missing parameters. example:
    echo "$0 <pcap file>"
    exit 1
fi

#get full path of pcap file.
PCAP=`readlink -f $1`
if [ ! -f $PCAP ]; then
    echo "$PCAP: file doesn't exist"
    exit 1
fi

#create fresh $PCAPD folder under current folder. folder is the pcap name without last extension
PCAPD=${PCAP%.*}
echo "create a fresh directory: $PCAPD"
rm -rf $PCAPD
mkdir $PCAPD

#PCAPCMD in the same directory of this script.
SCRIPT=`readlink -f ${0}`
SCRIPT_DIR=${SCRIPT%/*}
PCAP_CMD="${SCRIPT_DIR}/pcap"
#split pcap into different flows.
echo "Split $PCAP into seperate flows under $PCAPD"
echo "${PCAP_CMD} -s ${PCAP}"
pushd $PCAPD
$PCAP_CMD -s $PCAP
popd

YAML="$PCAPD.yaml"
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
#turn opt on to ignore empty directory.
shopt -s nullglob
for f in $PCAPD/*; do
    #ignore files without udp or tcp.
    if  [[ -n ${f##*tcp*} && -n ${f##*udp*} ]]; then
        continue
    fi

    cat >> $YAML << EOL
     - name: $f
       cps : 1
       ipg : 10000
       rtt : 10000
       w   : 1
EOL

done