export SBID=1249
for scan in $(ls -1d /data/TETHYS_1/craftop/data/SB0${SBID}/2* | cut -d / -f 7)
do
    echo $scan
    export SCANNAME=$scan
    time ./otf_pipe.sh
#    exit 1
done
export SCANNAME=
export SBID=
