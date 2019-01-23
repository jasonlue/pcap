if (($# != 1)); then
    echo missing parameters.
    exit 1
fi
rm -rf bro.$1
mkdir bro.$1
pushd bro.$1
bro -Qr ~/pcap/$1.pcap site/local.bro misc/loaded-scripts misc/profiling policy/protocols/smb > o.log 2>&1
popd
