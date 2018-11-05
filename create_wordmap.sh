#/bin/bash

if [ $# -ne 3 ]; then
   echo "usage: kws_scripts/create_wordmap.sh <text> <output_dir> <subword-type>"
   echo "e.g. kws_scripts/create_wordmap.sh data/yle-dev-new/text data/kws_prep/ char"
   echo "This script helps create specified subword maps for"
   echo "the text that is passed as an argument and stores"
   echo "it at the provided location."
   exit 1;
fi

text=$1
outdir=$2
stype=$3
bn=$(basename $text)

mkdir -p $outdir
mkdir -p $outdir/$stype
rm -f $outdir/$stype/$bn.wordmap
  
if [[ $stype == char ]]; then 
  for word in $(cat $text | tr ' ' '\n' | sort -u); do
    split=$(echo $word | grep -o .)
    echo $word $split >> $outdir/$stype/$bn.wordmap
  done
elif [[ $stype == morf ]]; then
  if ! [ -x "$(command -v python3)" ]; then
    echo "please, provide python3!"
    exit -1;
  fi

  if [ ! -f $outdir/allowed_chars ]; then
    echo "please, provide set of allowed character set at" 
    echo "$outdir/allowed_chars"
    exit -1;
  fi

  if [ ! -f $outdir/$stype/model.bin ]; then
    echo "please, provide Morfessor trained model to split"
    echo "words to morfs. this file should be available at"
    echo "$outdir/$stype/model.bin."
    exit -1;
  fi
  cat $text | tr ' ' '\n' | sort -u | python3 kws_scripts/create_morf_wordmap.py $outdir/allowed_chars $outdir/$stype/model.bin >> $outdir/$stype/$bn.wordmap
fi 
