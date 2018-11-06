#!/bin/bash

. common/slurm_dep_graph.sh

model_id=morfessor_f2_a0.05_tokens_aff

[ -f path.sh ] && . ./path.sh # source the path.
. parse_options.sh || exit 1;

model=

if [[ $model_id == char* ]]; then
  model=char
elif [[ $model_id == morf* ]]; then
  model=morf
fi


my_rttm_file="data/kws_prep/$model/ali/rttm"
my_ecf_file="data/kws_prep/ecf.xml"
my_kwlist_file="data/kws_prep/$model/kwlist_aff.xml"
lang_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/$model_id/v"
dataset_dir="data/yle-dev-new"

job kws_setup 10 50 NONE --  local_kws/kws_setup.sh --extraid $model --case_insensitive true --rttm-file $my_rttm_file $my_ecf_file $my_kwlist_file $lang_dir $dataset_dir
