#!/bin/bash

beam=15
f_cudafdmt=$(echo "/home/ban115/craft/craft/cuda-fdmt/cudafdmt/src/cudafdmt")
f_fof=$(echo "/home/ban115/craft/craft/python/fredfof.py")
rm -rf ant_list
for ant in $(ls -1d /data/TETHYS_1/ban115/craft/SB01048/20180309093159/c*)
do
    ant_name=$(echo $ant | tail -c 5)
    fil_file=$(ls -1 $ant/C*/*$beam.fil) 
    mjd=$(header $fil_file | grep "stamp" | cut -d : -f 2)
    echo $mjd > $ant_name.mjd
    echo $ant_name >> ant_list
    cmd="$f_cudafdmt -t 4096 -d 4096 -S 12 -r 1 -M 8 -T 32 -G 1 -m 10 -b 12  -z 6 -C 6 -u -x 7 "
    $cmd $fil_file -o $ant_name.cand
    $f_fof $ant_name.cand
    cat $ant_name.cand.fof | awk '{if (40 < $6 && $6  < 70) print $1, $2, $3, $4, $5, $6, $7}' | sort -gk1 > $ant_name.cand.fof.sorted
done
