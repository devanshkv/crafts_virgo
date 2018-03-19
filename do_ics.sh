#!/bin/bash

# On The Fly pipeline


#access the directory structure

Base_Dat_Dir=$(echo "/data/TETHYS_1/ban115/craft")
#Base_Dat_Dir="/data/TETHYS_1/sha355"
Base_Out_Dir=$(echo "/data/TETHYS_1/craftop/virgo/ics")
co_add=$(echo "/data/TETHYS_1/craftop/virgo/scripts/coadd/coadd_normed.py")
cudafdmt=$(echo "/home/ban115/craft/craft/cuda-fdmt/cudafdmt/src/cudafdmt")
fof=$(echo "/home/ban115/craft/craft/python/fredfof.py")
candcat=$(echo "/data/TETHYS_1/craftop/virgo/scripts/candcat.py")
candplt=$(echo "/data/TETHYS_1/craftop/virgo/scripts/cand_fq.sh")
fof_mbeam=$(echo "/data/TETHYS_1/craftop/virgo/scripts/fof_tethys_deep.sh")
export PATH=/home/sha355/bin/:$PATH
export SIGPYPROC=/home/craftop/sigpyproc
export LD_LIBRARY_PATH=$SIGPYPROC/lib/c:$LD_LIBRARY_PATH
export PYTHONPATH=$SIGPYPROC/lib/python:$PYTHONPATH


shed_block=$(echo "SB0${SBID}")
obs_blocks=$(ls -1d $Base_Out_Dir/$shed_block/$SCANNAME)


#for shed_block in $(echo "SB0${SBID}")
#do
#    for obs_blocks in $( ls -1d $Base_Dat_Dir/$shed_block/$SCANNAME )
#    do
#        # check if the scan closed
#        echo $obs_blocks 
#        if [ ! -f  $obs_blocks/SCAN_CLOSED ]; then
#            echo "Scan has not closed yet"
#            continue
#        fi
#
#        # make the file for the co_add.py to take as input
#        # make the observation block directory
#        # make a directory for the coadd lists
#        # make a directory for the filterbank beams
#        mkdir -p $Base_Out_Dir/$shed_block
        obs_block_dir=$(echo $obs_blocks | tail -c 15)
#        mkdir -p $Base_Out_Dir/$shed_block/$obs_block_dir
#
#        # the list of antenna beams live here
#        mkdir -p $Base_Out_Dir/$shed_block/$obs_block_dir/coadd_lists
#        # incoherent summed beams live here
#        mkdir -p $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams
#        
#        # for each beam make the list containing all beams from antennas
        for beam in $(seq -f "%02g" 0 35)
        do
            #rm -f $Base_Out_Dir/$shed_block/$obs_block_dir/coadd_lists/$beam.list
            #for antenna in $( ls -1d $obs_blocks/co?? )
            #do
            #    ls -1 $antenna/C*/*$beam.fil >> $Base_Out_Dir/$shed_block/$obs_block_dir/coadd_lists/$beam.list
            #done
        # for each beam in the beam list run the coadd.py and make incoherent summed beam
            if [ ! -f $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/$beam.fil ]; then
                codd_cmd="numactl --cpunodebind 0 $co_add"
                $codd_cmd -f $Base_Out_Dir/$shed_block/$obs_block_dir/coadd_lists/$beam.list -o $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/$beam.fil 
            else
                echo "$Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/$beam.fil exists"
            fi
            
            five_done=$(echo "($beam +1)%3" | bc )
            if [ "$five_done" -eq  "0" ] ; then
                wait
            fi
        
        done
#        wait
#        # now once the obs block is over run fredda and fof get the reduced candidate list
#        mkdir -p $Base_Out_Dir/$shed_block/$obs_block_dir/candidates
#        # rm -rf $Base_Out_Dir/$shed_block/$obs_block_dir/candidates/*
#        # running fredda as per ryan's script
#        # run fredda on 0-9, 10-19 on 2 GPUs then wait then execute rest
#        outfname=$(echo $Base_Out_Dir/$shed_block/$obs_block_dir/candidates/$obs_block_dir".cand")
#        logfname=$(echo $Base_Out_Dir/$shed_block/$obs_block_dir/candidates/$obs_block_dir".log")
#
#        if [[ -e $outfname ]] ; then
#            echo "Outfile $outfname exists. Skipping"
#            continue
#        fi
#        
#        cmd="numactl --cpunodebind 0  $cudafdmt -t 4096 -d 4096 -S 12 -r 1 -M 8 -T 8 -G 1 -m 10 -b 12  -z 6 -C 6 -x 7 -u"
#        gpu_id=$(echo "0")
#        # since fredda doesn't run on files with different start times, let's run them one by one
#        for fil_beam in $(seq -f "%02g" 0 35)
#        do
#            echo "runnning fredda ($fil_beam/35)"
#            cand_name=$(echo "$outfname.$fil_beam")
#            log_name=$(echo "$logfname.$fil_beam")
#            if [ "$gpu_id" == "0" ];
#            then
#                $cmd -o $cand_name -g $gpu_id $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/$fil_beam.fil 2>&1 > $log_name &
#                gpu_id=$(echo "1")
#            else
#                $cmd -o $cand_name -g $gpu_id $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/$fil_beam.fil 2>&1 > $log_name &
#                gpu_id=$(echo "0")
#                wait
#            fi
#        done
#        wait
#
#        # now this creates issues because all the beam numbers are zero! so lets fix that!
#        for fil_beam in $(seq -f "%02g" 0 35)
#        do
#          cat $outfname.$fil_beam | grep "#" > fil_head
#          cat $outfname.$fil_beam | grep -v "#" | awk -v fil_beam=$fil_beam '{$7 = fil_beam; print}' > fil_dat
#          cat fil_head fil_dat > $outfname.$fil_beam 
#        done
#
#
#        #echo "running fredda (1/2)"
#        #$cmd -o $outfname.0 -g 0 $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/0?.fil 2>&1 > $logfname.0 &
#        #$cmd -o $outfname.1 -g 1 $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/1?.fil 2>&1 > $logfname.1 &
#        #wait
#        #echo "running fredda (2/2)"
#        #$cmd -o $outfname.2 -g 0 $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/2?.fil 2>&1 > $logfname.2  &
#        #$cmd -o $outfname.3 -g 1 $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams/3[01234].fil  2>&1 > $logfname.3 &
#        
#        #$candcat -o 0,10,20,30 $outfname.0 $outfname.1 $outfname.2 $outfname.3 > $outfname
#        cat $outfname.* > $outfname
#
#        # run friends of friends
#        echo "running friends of friends"
#        #$fof $outfname 
#        $fof_mbeam $outfname
#        if grep -q PSR $antenna/C*/c*.hdr ; then
#            grep "TARGET PSR_" $antenna/C*/c*.hdr
#            echo "Observed a pulsar, skipped making candidate plots"
#            #$candplt $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams $Base_Out_Dir/$shed_block/$obs_block_dir/candidates $outfname.fof.mbeam.2
#        else
#            echo "Making candidate plots"
#            $candplt $Base_Out_Dir/$shed_block/$obs_block_dir/ics_beams $Base_Out_Dir/$shed_block/$obs_block_dir/candidates $outfname.fof.mbeam.2 &
#        fi
#        #exit  #remove this to stop only doing from one block
#    done
#done
