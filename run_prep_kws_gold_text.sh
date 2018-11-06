#!/bin/bash

kws_prep=data/kws_prep
dataset=data/yle-dev-new

[ -f path.sh ] && . ./path.sh # source the path.
. parse_options.sh || exit 1;


#extract dev ids
if [ ! -f $kws_prep/dev.ids ]; then
  cut -f1 -d' ' $dataset/text > $kws_prep/dev.ids
  cut -f2- -d' ' $dataset/text > $kws_prep/dev.txt
fi

for stype in char morf; do
  #create word map
  if [ ! -f $kws_prep/$stype/dev.txt.wordmap ]; then
    kws_scripts/create_wordmap.sh $kws_prep/dev.txt $kws_prep $stype
  fi

  #convert text to character subwords for KWS
  if [ ! -f $kws_prep/$stype/text_only ]; then
    python3 kws_scripts/prep_kws_gold_text.py $kws_prep/dev.txt $stype aff
  fi

  #paste dev ids to subword text
  if [ ! -f $kws_prep/$stype/text && -f $kws_prep/$stype/text_only ]; then
    paste -d' ' $kws_prep/dev.ids $kws_prep/$stype/text_only > $kws_prep/$stype/text
  fi
done

