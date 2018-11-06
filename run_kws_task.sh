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

model_id=chars_aff
model=

if [[ $model_id == char* ]]; then
  model=char
elif [[ $model_id == morf* ]]; then
  model=morf
fi

data_dir="data/yle-dev-new"

for lm in v; do #lin.knv.rnnvk_sami.p0.1.w0.5 lin.knv.rnnvk_sami.p0.1.w0.7 lin.knv.rnnvk_sami.p0.1.w0.9 lin.knv.rnnvk_sami.p0.1.w0.95 ; do #rnnvk_sami_p0.1; do #lin.knv.rnnvk_sami.p0.001.w0.5 lin.knv.rnnvk_sami.p0.001.w0.7 lin.knv.rnnvk_sami.p0.001.w0.9 lin.knv.rnnvk_sami.p0.001.w0.95 lin.knv.rnnvk_sami.p0.01.w0.5 lin.knv.rnnvk_sami.p0.01.w0.7 lin.knv.rnnvk_sami.p0.01.w0.9 lin.knv.rnnvk_sami.p0.01.w0.95 lin.knv.rnnvk_sami.p0.1.w0.5 lin.knv.rnnvk_sami.p0.1.w0.7 lin.knv.rnnvk_sami.p0.1.w0.9 lin.knv.rnnvk_sami.p0.1.w0.95 rnnvk_sami_p0.001 rnnvk_sami_p0.01 rnnvk_sami_p0.1; do

  lang_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/$lm"
  decode_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_${model_id}_${lm}_rnn_a_w1"

  #removing the word_boundary.int to use align_lexicon.int 
  #instead while creating kws indices. In our setup, we 
  #assume that kaldi script steps/make_index.sh uses an 
  #extra flag "--output-if-empty=true" when using the 
  #command "lattice-align-words-lexicon". A modified 
  #version is provided in this directory for reference.
  rm -f /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/$lm/phones/word_boundary.int

  if [ ! -f $decode_dir/.kws.done ] && [ ! -f $decode_dir/.done.kws ]; then
    job kws_search 100 36 NONE -- local_kws/kws_search.sh --cmd "$cmd" --extraid $model --max-states ${max_states} --min-lmwt ${min_lmwt} --max-lmwt ${max_lmwt} --skip-scoring $skip_scoring --indices-dir $decode_dir/kws_indices $lang_dir $data_dir $decode_dir
  fi

done
