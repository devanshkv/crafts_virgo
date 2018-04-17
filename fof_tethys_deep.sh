#!/bin/sh

#export CRAFT=/data/TITAN_1/ban115/craft/
#export PATH=$CRAFT/cuda-fdmt/cudafdmt/src:$CRAFT/python:$PATH

tmpdir=/data/TETHYS_1/craftop/virgo/tmp
mkdir -p $tmpdir
export PATH=/home/ban115/craft/craft/python/:${PATH}
#export PATH=/DATA/SKAHA_1/sha355/askap_fof/
export PYTHONPATH=/home/ban115/craft/craft/python/:${PYTHONPATH}

#arguments are output directory and output file

cand=$1

echo $cand
#rm ${cand}.fof
if [ ! -f ${cand}.fof.mbeam.2 ]; then
	
    for beam in `seq 0 35`; do 

	rm -f ${tmpdir}/tmp.${beam}
	rm -f ${tmpdir}/tmp.${beam}.fof
	
    awk -v beam=$beam '{if (($1 > 8) && ($4 < 20) && ($7 == beam) && ($6 > 50)) print $0}' $cand > ${tmpdir}/tmp.${beam} 
		
	ncand=`wc ${tmpdir}/tmp.${beam} | awk '{print $1}'`

#	echo $ncand
	if [ $ncand -gt 1 ]; then
#		echo "here"
		numactl --cpunodebind 0 fredfof.py ${tmpdir}/tmp.${beam}
	else
	    cp ${tmpdir}/tmp.${beam} ${tmpdir}/tmp.${beam}.fof
	fi
	
    done
    
    cat ${tmpdir}/tmp.*.fof > ${cand}.fof.mbeam.2	
    

fi
