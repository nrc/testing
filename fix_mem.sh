# DATEs:
declare -a dates=("2015-08-10-16-10-53")


TIMES_DIR=/root/times
BENCH_DIR=/root/benchmarks
SCRIPTS_DIR=/root/times-scripts

cd $TIMES_DIR

for i in "${dates[@]}"
do
   python $SCRIPTS_DIR/process.py rustc "$i" 3
done

cd $BENCH_DIR

for dir in *; do
    if [[ -d $dir ]]; then
        cd $TIMES_DIR
        for i in "${dates[@]}"
        do
           python $SCRIPTS_DIR/process.py $dir "$i" 6
        done

        cd $BENCH_DIR
    fi
done
