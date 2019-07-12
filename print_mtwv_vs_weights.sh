#!/bin/bash

model=morf
knv_plus_rnnv=/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_morfessor_f2_a0.05_tokens_aff_lin.knv.rnnvk_topk3.n13.p0.1.w
knv_plus_rnn5=/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_morfessor_f2_a0.05_tokens_aff_lin.knv.rnn5.p1.13.w

for w in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95; do 
  mtwv1=$(grep MTWV ${knv_plus_rnnv}${w}/${model}_kws_*/metrics.txt | sort -nk3 | tail -n1| cut -f3 -d' '); 
  mtwv2=$(grep MTWV ${knv_plus_rnn5}${w}/${model}_kws_*/metrics.txt | sort -nk3 | tail -n1| cut -f3 -d' '); 
  echo $w $mtwv1 $mtwv2; 
done > data/interspeech_2019/morf_weights_mtwv.dat

model=char
knv_plus_rnnv=/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_lin.knv.rnnvk_topk3.n5.p0.1.w
knv_plus_rnn5=/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_lin.knv.rnn5.p0.008.w

for w in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95; do 
  mtwv1=$(grep MTWV ${knv_plus_rnnv}${w}/${model}_kws_*/metrics.txt | sort -nk3 | tail -n1| cut -f3 -d' '); 
  mtwv2=$(grep MTWV ${knv_plus_rnn5}${w}/${model}_kws_*/metrics.txt | sort -nk3 | tail -n1| cut -f3 -d' '); 
  echo $w $mtwv1 $mtwv2; 
done > data/interspeech_2019/char_weights_mtwv.dat
