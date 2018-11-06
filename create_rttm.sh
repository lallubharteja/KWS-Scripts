#!/bin/bash

. common/slurm_dep_graph.sh

prev=NONE
model=

ivecs=exp/chain/model/all_tdnn_blstm_9_a/ivecs/ivectors_yle-dev-new/
dataset=data/yle-dev-new


[ -f path.sh ] && . ./path.sh # source the path.
. parse_options.sh || exit 1;

#This scripts runs jobs to create the ali directory and then runs the job
#to create rttm file. 

for model_id in morfessor_f2_a0.05_tokens_aff ; do #morfessor_f2_a0.05_tokens_aff ; do 
  if [[ $model_id == char* ]]; then
    model=char
  elif [[ $model_id == morf* ]]; then
    model=morf
  fi

  feats=exp/chain/model/all_tdnn_blstm_9_a/feats/yle-dev-new-$model/
  lang=/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/v
  ali=exp/chain/model/all_tdnn_blstm_9_a data/kws_prep/$model/ali

  if [ ! -f data/kws_prep/$model/ali/ali.1.gz ]; then
    job create_dev_ali 4 2 NONE -- steps/nnet3/align.sh --nj 100 --retry-beam 300 --online-ivector-dir $ivecs --scale-opts '--transition-scale=1.0 --acoustic-scale=1.0 --self-loop-scale=1.0' --cmd slurm.pl --use_gpu false $feats $lang $ali
  prev=create_dev_ali
  fi
  
  #In our subword asr setup, segment (utterance) information is not saved during 
  #the decoding process, we assume that local_kws/ali_to_rttm.sh is suitably 
  #modified to not include segment file information while creating rttm. A modified 
  #version is include in this repo and needs to be placed in the directory
  #local_kws before running this script.

  if [ ! -f data/kws_prep/$model/ali/rttm ]; then
    job create_rttm 4 50 $prev -- local_kws/ali_to_rttm.sh $dataset $langs $ali
  fi

done
