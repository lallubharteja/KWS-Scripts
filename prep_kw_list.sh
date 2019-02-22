#!/bin/bash

#Run jobs to create character- and morpheme-based keyword list

if [ ! -f data/kws_prep/char/kwlist_aff.txt ] ;then
  python3 kws_scripts/prep_kw_list.py data/kws_prep/oov.list aff > data/kws_prep/char/kwlist_aff.txt
fi

if [ ! -f data/kws_prep/morf/kwlist_aff.txt ]; then 
  python3 kws_scripts/prep_morf_kw_list.py data/kws_prep/kw.list aff /scratch/work/psmit/chars-fin-2017/lm/all/morfessor_f2_a0.05_tokens/model.bin > data/kws_prep/morf/kwlist_aff.txt
fi

if [ ! -f data/kws_prep/word/kwlist.txt ]; then
  mkdir -p data/kws_prep/word
  cp data/kws_prep/kw.list data/kws_prep/word/kwlist.txt
fi
