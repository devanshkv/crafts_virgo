export SBID=1055
for scan in $(ls -1d /data/TETHYS_1/ban115/craft/SB01055/2* | cut -d / -f 7)
do
    echo $scan
    export SCANNAME=$scan
    time ./otf_pipe.sh
done
export SCANNAME=
export SBID=
