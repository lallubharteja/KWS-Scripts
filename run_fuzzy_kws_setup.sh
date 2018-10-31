
#!/bin/bash

. common/slurm_dep_graph.sh

[ -f path.sh ] && . ./path.sh # source the path.
. parse_options.sh || exit 1;

decode_cmd="run.pl"
my_nj=50

my_rttm_file="data/kws_prep/char/ali/rttm"
my_ecf_file="data/kws_prep/ecf.xml"
my_kwlist_file="data/kws_prep/char/kwlist_aff.txt"
lang_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/chars_aff/v"
dataset_dir="data/yle-dev-new"

data_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/graph_chars_aff_v/"
model_dir="exp/chain/model/all_tdnn_blstm_9_a"
ali_dir="data/kws_prep/ali"
decode_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_v"

conf_matrix="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/conf_yle-dev-new_chars_aff_v"
g2p="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/g2p_yle-dev-new_chars_aff_v"

lang_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/data/langs/chars_aff/v"

#Generate the confusion matrix
#NB, this has to be done only once, as it is training corpora dependent,
#instead of search collection dependent
if [ ! -f $conf_matrix/.done ] ; then
  local_kws/generate_confusion_matrix.sh --cmd "$decode_cmd" --nj $my_nj  \
    $data_dir $model_dir $ali_dir $decode_dir  $conf_matrix
  touch $conf_matrix/.done
fi
confusion=$conf_matrix/confusions.txt

if [ ! -f $g2p/.done ] ; then
  local_kws/train_g2p.sh $lang_dir/local $g2p
  touch $g2p/.done
fi
local_kws/apply_g2p.sh --nj $my_nj --cmd "$decode_cmd" \
  $my_kwlist_file $g2p $kwsdatadir/g2p
L2_lex=$kwsdatadir/g2p/lexicon.lex

L1_lex=$lang_dir/local/lexiconp.txt
local_kws/kws_data_prep_proxy.sh \
  --cmd "$decode_cmd" --nj $my_nj \
  --case-insensitive true \
  --confusion-matrix $confusion \
  --phone-cutoff $phone_cutoff \
  --pron-probs true --beam $beam --nbest $nbest \
  --phone-beam $phone_beam --phone-nbest $phone_nbest \
  data/lang  $data_dir $L1_lex $L2_lex $kwsdatadir
