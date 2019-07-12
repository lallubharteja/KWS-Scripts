#!/bin/bash

. common/slurm_dep_graph.sh

set -e
set -o pipefail
set -u

#Begin options
min_lmwt=8
max_lmwt=12
cer=0
skip_scoring=false
cmd=run.pl
max_states=150000
wip=0.5 #Word insertion penalty
#End of options

[ -f path.sh ] && . ./path.sh # source the path.
echo $0 "$@"
. utils/parse_options.sh

if [ $# -ne 0 ]; then
  echo "Usage: $0 [options] <data-dir> <lang-dir> <decode-dir>"
  echo " e.g.: $0 data/dev10h data/lang exp/tri6/decode_dev10h"
  exit 1;
fi

JOB_PREFIX=$(cat id)_

model_id=chars_aff10
model=

if [[ $model_id == char* ]]; then
  model=char
elif [[ $model_id == morf* ]]; then
  model=morf
fi

data_dir="data/yle-dev-new"
#for k in topk6 ; do #topk1 topk2 topk3 topk4 topk5 topk6; do   
for lm in "estonian-arch5" "english-1x-arch5" ; do #"fin-arch5" "estonian-arch1" "estonian-arch3" "estonian-arch4" "english-1x-arch1" "english-1x-arch3" "english-1x-arch4" "en-1x-fi-low-arch1" "en-1x-fi-low-arch3" "en-1x-fi-low-arch4" "en-1x-fi-low-arch5" "et-fi-low-arch1" "et-fi-low-arch3" "et-fi-low-arch4" "et-fi-low-arch5" ; do #rnnvk_${k}_n3_p0.1 rnnvk_${k}_n3_p0.1 rnnvk_${k}_n4_p0.1 ; do #rnnvk_${k}_n15_p0.1 rnnvk_${k}_n16_p0.1 rnnvk_${k}_n17_p0.1 rnnvk_${k}_n18_p0.1 rnnvk_${k}_n19_p0.1 rnnvk_${k}_n20_p0.1 rnnvk_${k}_n21_p0.1 rnnvk_${k}_n22_p0.1 rnnvk_${k}_n23_p0.1 rnnvk_${k}_n24_p0.1 rnnvk_${k}_n25_p0.1 rnnvk_${k}_n26_p0.1 rnnvk_${k}_n27_p0.1 rnnvk_${k}_n28_p0.1  rnnvk_${k}_n5_p0.1 rnnvk_${k}_n6_p0.1 rnnvk_${k}_n7_p0.1 rnnvk_${k}_n8_p0.1 rnnvk_${k}_n9_p0.1; do #rnnvk_${k}_n29_p0.1 rnnvk_${k}_n30_p0.1 rnnvk_${k}_n31_p0.1 rnnvk_${k}_n32_p0.1 rnnvk_${k}_n33_p0.1 rnnvk_${k}_n35_p0.1

#lin.knv.rnnvk_topk3.n5.p0.1.w0.1  lin.knv.rnnvk_topk3.n5.p0.1.w0.2  lin.knv.rnnvk_topk3.n5.p0.1.w0.3 lin.knv.rnnvk_topk3.n5.p0.1.w0.4; do 

#lin.knv.rnnvk_topk6.n10.p0.1.w0.5 lin.knv.rnnvk_topk6.n11.p0.1.w0.5 lin.knv.rnnvk_topk6.n12.p0.1.w0.5 lin.knv.rnnvk_topk6.n13.p0.1.w0.5 lin.knv.rnnvk_topk6.n14.p0.1.w0.5 lin.knv.rnnvk_topk6.n15.p0.1.w0.5 lin.knv.rnnvk_topk6.n16.p0.1.w0.5 lin.knv.rnnvk_topk6.n17.p0.1.w0.5 lin.knv.rnnvk_topk6.n18.p0.1.w0.5 lin.knv.rnnvk_topk6.n19.p0.1.w0.5 lin.knv.rnnvk_topk6.n20.p0.1.w0.5 lin.knv.rnnvk_topk6.n21.p0.1.w0.5 lin.knv.rnnvk_topk6.n22.p0.1.w0.5 lin.knv.rnnvk_topk6.n23.p0.1.w0.5 lin.knv.rnnvk_topk6.n24.p0.1.w0.5 lin.knv.rnnvk_topk6.n25.p0.1.w0.5 lin.knv.rnnvk_topk6.n26.p0.1.w0.5 lin.knv.rnnvk_topk6.n27.p0.1.w0.5 lin.knv.rnnvk_topk6.n28.p0.1.w0.5 lin.knv.rnnvk_topk6.n29.p0.1.w0.5 lin.knv.rnnvk_topk6.n30.p0.1.w0.5 lin.knv.rnnvk_topk6.n31.p0.1.w0.5 lin.knv.rnnvk_topk6.n32.p0.1.w0.5 lin.knv.rnnvk_topk6.n33.p0.1.w0.5 lin.knv.rnnvk_topk6.n34.p0.1.w0.5 lin.knv.rnnvk_topk6.n5.p0.1.w0.5 lin.knv.rnnvk_topk6.n6.p0.1.w0.5 lin.knv.rnnvk_topk6.n7.p0.1.w0.5 lin.knv.rnnvk_topk6.n8.p0.1.w0.5 lin.knv.rnnvk_topk6.n9.p0.1.w0.5 ; do 

# lin.knv.rnnvk_sami.n10.p0.001.w0.5 lin.knv.rnnvk_sami.n11.p0.001.w0.5 lin.knv.rnnvk_sami.n12.p0.001.w0.5 lin.knv.rnnvk_sami.n13.p0.001.w0.5 lin.knv.rnnvk_sami.n14.p0.001.w0.5 lin.knv.rnnvk_sami.n15.p0.001.w0.5 lin.knv.rnnvk_sami.n16.p0.001.w0.5 lin.knv.rnnvk_sami.n17.p0.001.w0.5 lin.knv.rnnvk_sami.n18.p0.001.w0.5 lin.knv.rnnvk_sami.n19.p0.001.w0.5 lin.knv.rnnvk_sami.n20.p0.001.w0.5 lin.knv.rnnvk_sami.n21.p0.001.w0.5 lin.knv.rnnvk_sami.n22.p0.001.w0.5 lin.knv.rnnvk_sami.n23.p0.001.w0.5 lin.knv.rnnvk_sami.n24.p0.001.w0.5 lin.knv.rnnvk_sami.n25.p0.001.w0.5 lin.knv.rnnvk_sami.n26.p0.001.w0.5 lin.knv.rnnvk_sami.n27.p0.001.w0.5 lin.knv.rnnvk_sami.n28.p0.001.w0.5 lin.knv.rnnvk_sami.n5.p0.001.w0.5 lin.knv.rnnvk_sami.n6.p0.001.w0.5 lin.knv.rnnvk_sami.n7.p0.001.w0.5 lin.knv.rnnvk_sami.n8.p0.001.w0.5 lin.knv.rnnvk_sami.n9.p0.001.w0.5; do # lin.knv.rnn5.p0.011.w0.5 lin.knv.rnn5.p0.011.w0.55 lin.knv.rnn5.p0.011.w0.6 lin.knv.rnn5.p0.011.w0.65 lin.knv.rnn5.p0.011.w0.7 lin.knv.rnn5.p0.011.w0.75 lin.knv.rnn5.p0.011.w0.8 lin.knv.rnn5.p0.011.w0.85 lin.knv.rnn5.p0.011.w0.9 lin.knv.rnn5.p0.011.w0.95 lin.knv.rnnvk_sami.p0.1.w0.5 lin.knv.rnnvk_sami.p0.1.w0.55 lin.knv.rnnvk_sami.p0.1.w0.6 lin.knv.rnnvk_sami.p0.1.w0.65 lin.knv.rnnvk_sami.p0.1.w0.7 lin.knv.rnnvk_sami.p0.1.w0.75 lin.knv.rnnvk_sami.p0.1.w0.8 lin.knv.rnnvk_sami.p0.1.w0.85 lin.knv.rnnvk_sami.p0.1.w0.9 lin.knv.rnnvk_sami.p0.1.w0.95; do #rnn5_p0.011 lin.knv.rnn5.p0.011.w0.5 lin.knv.rnnvk_sami.p0.1.w0.5 lin.knv.rnnvk_sami.p0.1.w0.7 lin.knv.rnnvk_sami.p0.1.w0.9 lin.knv.rnnvk_sami.p0.1.w0.95 ; do #rnnvk_sami_p0.1; do #lin.knv.rnnvk_sami.p0.001.w0.5 lin.knv.rnnvk_sami.p0.001.w0.7 lin.knv.rnnvk_sami.p0.001.w0.9 lin.knv.rnnvk_sami.p0.001.w0.95 lin.knv.rnnvk_sami.p0.01.w0.5 lin.knv.rnnvk_sami.p0.01.w0.7 lin.knv.rnnvk_sami.p0.01.w0.9 lin.knv.rnnvk_sami.p0.01.w0.95 lin.knv.rnnvk_sami.p0.1.w0.5 lin.knv.rnnvk_sami.p0.1.w0.7 lin.knv.rnnvk_sami.p0.1.w0.9 lin.knv.rnnvk_sami.p0.1.w0.95 rnnvk_sami_p0.001 rnnvk_sami_p0.01 rnnvk_sami_p0.1; do

  #lang_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/$lm"
  lang_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/v"
  #decode_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_${model_id}_${lm}"
  decode_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_v10_rnn_${lm}_nnlm.w1.lms213.rtb"
  #decode_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_v10_rnn_fin-arch5_nnlm.w1.lms213.rtb_interp_${lm}_nnlm.w1.lms213.rtb/best"

  #removing the word_boundary.int to use align_lexicon.int 
  #instead while creating kws indices. In our setup, we 
  #assume that kaldi script steps/make_index.sh uses an 
  #extra flag "--output-if-empty=true" when using the 
  #command "lattice-align-words-lexicon". A modified 
  #version is provided in this directory for reference.
  rm -f /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/$lm/phones/word_boundary.int

  if [ ! -f $decode_dir/.kws.done ] && [ ! -f $decode_dir/.done.kws ]; then
    #job kws_search 50 10 NONE -- local_kws/kws_search.sh --cmd "$cmd" --extraid $model --max-states ${max_states} --min-lmwt ${min_lmwt} --max-lmwt ${max_lmwt} --skip-scoring $skip_scoring --indices-dir $decode_dir/kws_indices $lang_dir $data_dir $decode_dir
    job kws_search 50 10 NONE -- local_kws/kws_search.sh --cmd "$cmd" --extraid $model --max-states ${max_states} --min-lmwt ${min_lmwt} --max-lmwt ${max_lmwt} --skip-scoring $skip_scoring --indices-dir $decode_dir/kws_indices --model "/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/final.mdl" $lang_dir $data_dir $decode_dir
  fi

done
#done
