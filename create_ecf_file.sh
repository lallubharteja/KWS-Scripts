if [ $# -ne 2 ]; then
   echo "usage: kws_scripts/create_ecf_file.sh <wav file lists> <output file>"
   echo "e.g.:  kws_scripts/create_ecf_file.sh data/yle-dev-new/wav.scp data/kws_prep/ecf.xml"
   exit 1;
fi

wav_files=$1
output_file=$2
total_duration=0

for f in $(cut -f2 -d' ' $wav_files); do 
  dur=$(sox $f -n stat 2>&1 | sed -n 's#^Length (seconds):[^0-9]*\([0-9.]*\)$#\1#p')
  echo '<excerpt audio_filename="'$f'" channel="1" tbeg="0.000" dur="'$dur'" source_type="splitcts"/>' >> $output_file
  total_duration=$(perl -E "say $total_duration + $dur")
done
echo '<ecf source_signal_duration="'$total_duration'" language="" version="Excluded noscore regions">' >> $output_file
sed -i '1h;1d;$!H;$!d;G' $output_file
echo "</ecf>" >> $output_file
