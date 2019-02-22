#!/bin/bash

if [ $# -ne 2 ]; then
   echo "usage: kws_scripts/create_ecf_file.sh <wav file lists> <output location>"
   echo "e.g.:  kws_scripts/create_ecf_file.sh data/yle-dev-new/wav.scp data/kws_prep/ecf.xml"
   echo "This script creates the experiment control file (ECF) required"
   echo "by NIST F4DE's KWS evaluation."
   exit 1;
fi

. ./path.sh

wav_files=$1
output_file=$2
total_duration=0

outdir=$(dirname $output_file)

wav-to-duration scp:$wav_files ark,t:- > $outdir/dur.txt 

for id in $(cut -f1 -d' ' $wav_files); do
  dur=$(grep $id $outdir/dur.txt| cut -f2 -d' ')
  f=$(grep $id $wav_files| cut -f2 -d' ')
  echo '<excerpt audio_filename="'$f'" channel="1" tbeg="0.000" dur="'$dur'" source_type="splitcts"/>' >> $output_file
  total_duration=$(perl -E "say $total_duration + $dur")
done

echo '<ecf source_signal_duration="'$total_duration'" language="" version="Excluded noscore regions">' >> $output_file
sed -i '1h;1d;$!H;$!d;G' $output_file
echo "</ecf>" >> $output_file
