#!/bin/bash

. common/slurm_dep_graph.sh

[ -f path.sh ] && . ./path.sh # source the path.
. parse_options.sh || exit 1;

prev=NONE
model=
for model_id in morfessor_f2_a0.05_tokens_aff ; do #morfessor_f2_a0.05_tokens_aff ; do 
  if [[ $model_id == char* ]]; then
    model=char
  elif [[ $model_id == morf* ]]; then
    model=morf
  fi

  if [ ! -f data/kws_prep/$model/ali/ali.1.gz ]; then
    job create_dev_ali 4 2 NONE -- steps/nnet3/align.sh --nj 100 --retry-beam 300 --online-ivector-dir exp/chain/model/all_tdnn_blstm_9_a/ivecs/ivectors_yle-dev-new/ --scale-opts '--transition-scale=1.0 --acoustic-scale=1.0 --self-loop-scale=1.0' --cmd slurm.pl --use_gpu false exp/chain/model/all_tdnn_blstm_9_a/feats/yle-dev-new-$model/ /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/v exp/chain/model/all_tdnn_blstm_9_a data/kws_prep/$model/ali 
  prev=create_dev_ali
  fi
  if [ ! -f data/kws_prep/$model/ali/rttm ]; then
    job create_rttm 4 50 $prev -- local_kws/ali_to_rttm.sh data/yle-dev-new /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/v data/kws_prep/$model/ali
  fi

done
