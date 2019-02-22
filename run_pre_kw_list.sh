#!/bin/bash

kws_prep=data/kws_prep
#specify the subword segmentation or leave it empyt for words
#btype=aff
btype=
morf_model=/scratch/work/psmit/chars-fin-2017/lm/all/morfessor_f2_a0.05_tokens/model.bin

[ -f path.sh ] && . ./path.sh # source the path.
echo $0 "$@"
. utils/parse_options.sh

#create kws word lists
for stype in char morf word; do

   if [[ $stype == char ]]; then
    btype=aff
  elif [[ $stype == morf ]]; then
    btype=aff
  elif [[ $stype == word ]]; then
    btype=""
  fi 

  if [ ! -f $kws_prep/$stype/kwlist_$btype.txt ]; then
    if [[ $stype == morf ]]; then
      python3 kws_scripts/prep_morf_kw_list.py $kws_prep/oov.list $btype $morf_model |  grep -v "<UNK>" > $kws_prep/$stype/kwlist_$btype.tmp 
      cat $kws_prep/$stype/kwlist_$btype.tmp | awk '{if (length() > 1) {print $0}}'  > $kws_prep/$stype/kwlist_$btype.txt
    elif [[ $stype == word ]]; then
      mkdir -p data/kws_prep/word
      #hacky way of keeping the keywords same for word models
      cat $kws_prep/morf/kwlist_aff.txt | tr -d '+'| tr -d ' ' | grep -v "<UNK>" > data/kws_prep/word/kwlist_$btype.txt
    else
      python3 kws_scripts/prep_kw_list.py $kws_prep/oov.list $btype |  grep -v "<UNK>" > $kws_prep/$stype/kwlist_$btype.tmp  
      cat $kws_prep/$stype/kwlist_$btype.tmp | awk '{if (NF > 1) {print $0}}'  > $kws_prep/$stype/kwlist_$btype.txt
    fi        
  fi

  if [ ! -f $kws_prep/$stype/kwlist_$btype.xml ]; then
    echo '<kwlist ecf_filename="ecf.xml" language="Finnish" encoding="UTF-8" compareNormalize="" version="Example keywords">' > $kws_prep/$stype/kwlist_$btype.xml
    n=1
    while IFS='' read -r line || [[ -n "$line" ]]; do
      echo '  <kw kwid="'$n'">' >> $kws_prep/$stype/kwlist_$btype.xml
      echo '    <kwtext>'$line'</kwtext>' >> $kws_prep/$stype/kwlist_$btype.xml
      echo '  </kw>' >> $kws_prep/$stype/kwlist_$btype.xml
      n=`expr $n + 1` 
    done < $kws_prep/$stype/kwlist_$btype.txt
    echo '</kwlist>' >> $kws_prep/$stype/kwlist_$btype.xml
  fi
done
