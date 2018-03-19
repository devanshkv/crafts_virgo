#!/bin/bash


cand_list_file=$3
fil_file_loc=$1
cand_out_loc=$2
cat $cand_list_file | grep -v "#" | sort -grk 1 | while read line
do
    echo $line
    ./fold_cand.sh $fil_file_loc $cand_out_loc $line
done
