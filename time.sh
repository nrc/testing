# Pulls current rust and benchmarks it.

TIMES_DIR=/root/times
BENCH_DIR=/root/benchmarks
SCRIPTS_DIR=/root/times-scripts

export DATE=$(date +%F_%H-%M-%S)
START=$(pwd)

echo "pulling master"
git checkout master
git pull origin master

echo "building"

./configure
make rustc-stage1 -j8

export RUSTFLAGS_STAGE2=-Ztime-passes

for i in 0 1 2
do
    echo "building, round $i"
    git show HEAD -s >$TIMES_DIR/raw/rustc--$DATE--$i.log
    touch src/librustc_trans/trans/mod.rs
    make >>$TIMES_DIR/raw/rustc--$DATE--$i.log
done

echo "processing data"
cd $TIMES_DIR
python $SCRIPTS_DIR/process.py rustc $DATE 3
for i in 0 1 2
do
    git add raw/rustc--$DATE--$i.log
    git add processed/rustc--$DATE--$i.json
done

echo "benchmarks"
export RUSTC=$START/x86_64-unknown-linux-gnu/stage2/bin/rustc
export LD_LIBRARY_PATH=$START/x86_64-unknown-linux-gnu/stage2/lib
cd $BENCH_DIR
./process.sh

echo "committing"
cd $TIMES_DIR
git commit -m "Added data for $DATE"
git push upstream master
