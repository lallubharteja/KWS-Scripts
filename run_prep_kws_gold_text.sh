#!/bin/bash

for model in char morf; do
  if [ ! -f data/kws_prep/$model/dev.txt.wordmap ]; then
    kws_scripts/create_wordmap.sh data/kws_prep/dev.txt data/kws_prep/ $model
  fi
  
  if [ ! -f data/kws_prep/$model/text_only ]; then
    python3 kws_scripts/prep_kws_gold_text.py data/kws_prep/dev.txt ${model}_aff
  fi
  
  if [ ! -f data/kws_prep/$model/text && -f data/kws_prep/$model/text_only ]; then
    paste -d ' ' data/kws_prep/dev.ids data/kws_prep/$model/text_only > data/kws_prep/$model/text
  fi
done
