htop -p $(pgrep ^bro$ | xargs | tr ' ' ',')
