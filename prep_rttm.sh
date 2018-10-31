#!/bin/bash

# create word map
if [ ! -f data/kws_prep/char/dev.txt.wordmap ]; then
  kws_scripts/create_char_wordmap.sh data/kws_prep/dev.txt
fi

# convert text to character subwords for KWS
if [ ! -f data/kws_prep/char/text_only ]; then
  python3 kws_scripts/prep_kws_gold_text.py data/kws_prep/dev.txt char_aff
fi

if [ ! -f data/kws_prep/dev.ids ]; then
  cut -f1 -d' ' data/yle-dev-new/text > data/kws_prep/dev.ids
fi

if [ ! -f data/kws_prep/char/text ]; then
  paste -d' ' data/kws_prep/dev.ids data/kws_prep/char/text_only > data/kws_prep/char/text
fi

