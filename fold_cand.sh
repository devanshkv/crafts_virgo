#!/bin/bash

basename=$1
outdir=$2
DM=$8
s_time=$5
beam=$9

echo "dm: " $DM " time: " $s_time " beam: " $beam

if [ $beam -lt 10 ]; then
    inname=${basename}/0${beam}.fil
else
    inname=${basename}/${beam}.fil
fi

outname=$(echo $outdir"/"$DM"_"$s_time)

echo $inname $outname

tsamp=0.00126646875
bin=4096
length=`python -c  "print $tsamp * $bin"`
offset=`python -c "print $length / 2."`
echo $length $offset


timeoff=`python -c "print $s_time - $offset"`

echo $timeoff

dspsr -c $length -S $timeoff -cepoch=start -T $length -b $bin -D $DM -O $outname $inname

psrplot -jDT -pfreq+ ${outname}.ar -D /PNG
mv pgplot.png $outname.png
