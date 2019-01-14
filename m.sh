grep Memory prof.log | sed '1d' | awk '{print $1,$6}' | sed 's/K//g' | sed 's/\..* / /g' > m.log
