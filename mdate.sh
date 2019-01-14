grep Memory prof.log | sed '1d' | awk '{print strftime("%Y-%m-%d %H:%M:%S",$1),$6}' | sed 's/K//g' | sed 's/\..* / /g'
