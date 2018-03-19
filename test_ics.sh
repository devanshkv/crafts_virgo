export SBID=1055
for scan in $(ls -1d /data/TETHYS_1/craftop/virgo/ics/SB01055/2* | cut -d / -f 8)
do
    echo $scan
    export SCANNAME=$scan
    time ./do_ics.sh
    exit 1
done
export SCANNAME=
export SBID=
