while read p; do
  ./nightly.sh $p
done <dates.txt
