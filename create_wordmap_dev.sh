text=$1
stype=$2
  
mkdir -p data/kws_prep
dev=$(basename $text)
rm -f data/kws_prep/$stype/$dev.wordmap

if [[ $stype == char ]]; then 
  for word in $(cat $text | tr ' ' '\n' | sort -u); do
    split=$(echo $word | grep -o .)
    echo $word $split >> data/kws_prep/$stype/$dev.wordmap
  done
elif [[ $stype == morf ]]; then
  cat $text | tr ' ' '\n' | sort -u | python3 kws_scripts/create_morf_wordmap.py data/kws_prep/allowed_chars data/kws_prep/morf/model.bin aff >> data/kws_prep/$stype/$dev.wordmap
fi 
