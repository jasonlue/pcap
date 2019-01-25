#!/bin/bash
#this will take forever to finish. esp. 10M 100M as input. massif may take more than 24 hours. run wih caution.
input=(1K 10K 100K 1M 10M 100M)
cmd=(run prof massif)

for i in ${input[@]}; do
    for c in ${cmd[@]}; do
        if [ ! -d bro-$i-$c ]; then
            bro.sh $i $c
        fi
    done
done
