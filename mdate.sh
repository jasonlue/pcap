#!/bin/bash
if (($# != 1)); then
	echo "missing parameters"
	echo "$0 <prof.log>"
	exit 1
fi

grep Memory $1 | sed '1d' | awk '{$1=strftime("%Y-%m-%d %H:%M:%S",$1); print $0}' 
