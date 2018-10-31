#!/bin/bash


for lm in char morf; do 

  if [ ! -f data/kws_prep/$lm/kwlist_aff.txt ]; then
    if [[ $lm == morf ]]; then
      python3 kws_scripts/prep_morf_kw_list.py data/kws_prep/$lm/kwlist_aff /scratch/work/psmit/chars-fin-2017/lm/all/morfessor_f2_a0.05_tokens/model.bin |  grep -v "<UNK>" > data/kws_prep/$lm/kwlist_aff.tmp 
      cat data/kws_prep/$lm/kwlist_aff.tmp | awk '{if (length() > 1) {print $0}}'  > data/kws_prep/$lm/kwlist_aff.txt
    else
      python3 kws_scripts/prep_kw_list.py data/kws_prep/$lm/kwlist_aff |  grep -v "<UNK>" > data/kws_prep/$lm/kwlist_aff.tmp  
      cat data/kws_prep/$lm/kwlist_aff.tmp | awk '{if (NF > 1) {print $0}}'  > data/kws_prep/$lm/kwlist_aff.txt
    fi        
  fi

  if [ ! -f data/kws_prep/$lm/kwlist_aff.xml ]; then
    echo '<kwlist ecf_filename="ecf.xml" language="Finnish" encoding="UTF-8" compareNormalize="" version="Example keywords">' > data/kws_prep/$lm/kwlist_aff.xml
    n=1
    while IFS='' read -r line || [[ -n "$line" ]]; do
      echo '  <kw kwid="'$n'">' >> data/kws_prep/$lm/kwlist_aff.xml
      echo '    <kwtext>'$line'</kwtext>' >> data/kws_prep/$lm/kwlist_aff.xml
      echo '  </kw>' >> data/kws_prep/$lm/kwlist_aff.xml
      n=`expr $n + 1` 
    done < data/kws_prep/$lm/kwlist_aff.txt
    echo '</kwlist>' >> data/kws_prep/$lm/kwlist_aff.xml
  fi
done
