#/bin/bash

# create character word maps for the text that is passed as an argument

text=$1
bn=$(basename $text)
mkdir -p data/kws_prep
rm -f data/kws_prep/char/$bn.wordmap
for word in $(cat $text | tr ' ' '\n' | sort -u); do
  split=$(echo $word | grep -o .)
  echo $word $split >> data/kws_prep/char/$bn.wordmap
done
