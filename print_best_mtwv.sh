#!/bin/bash

set -e
set -o pipefail
set -u

#Begin options
metric=MTWV
col=3
#End of options

. utils/parse_options.sh

if [ $# -ne 0 ]; then
  echo "Usage: $0 [options] <data-dir> <lang-dir> <decode-dir>"
  echo " e.g.: $0 data/dev10h data/lang exp/tri6/decode_dev10h"
  exit 1;
fi

JOB_PREFIX=$(cat id)_

model_id=chars_aff

for lm in rnnvk_sami_n10_p0.1 rnnvk_sami_n11_p0.1 rnnvk_sami_n12_p0.1 rnnvk_sami_n13_p0.1 rnnvk_sami_n14_p0.1 rnnvk_sami_n15_p0.1 rnnvk_sami_n16_p0.1 rnnvk_sami_n17_p0.1 rnnvk_sami_n18_p0.1 rnnvk_sami_n19_p0.1 rnnvk_sami_n20_p0.1 rnnvk_sami_n21_p0.1 rnnvk_sami_n22_p0.1 rnnvk_sami_n23_p0.1 rnnvk_sami_n2_p0.1 rnnvk_sami_n3_p0.1 rnnvk_sami_n4_p0.1 rnnvk_sami_n5_p0.1 rnnvk_sami_n6_p0.1 rnnvk_sami_n7_p0.1 rnnvk_sami_n8_p0.1 rnnvk_sami_n9_p0.1; do #rnnvk_sami_n24_p0.1 rnnvk_sami_n25_p0.1 rnnvk_sami_n26_p0.1 rnnvk_sami_n27_p0.1 rnnvk_sami_n28_p0.1 
  decode_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_${model_id}_${lm}"
  val=$(cat ${decode_dir}/char_kws_*/metrics.txt | grep ${metric} | awk -v C=$col '{print $C}' | sort -nr | head -n1)
  order=$(echo $lm | cut -f3 -d'_' | tr -d 'n')
  echo "$order $val" >> data/results/rnnvk_sami_mtwv.tmp
done 
sort -nk1 data/results/rnnvk_sami_mtwv.tmp > data/results/rnnvk_sami_mtwv.dat
rm data/results/rnnvk_sami_mtwv.tmp


for n in 1 2 3 4 5 6; do
for lm in rnnvk_topk${n}_n10_p0.1 rnnvk_topk${n}_n11_p0.1 rnnvk_topk${n}_n12_p0.1 rnnvk_topk${n}_n13_p0.1 rnnvk_topk${n}_n14_p0.1 rnnvk_topk${n}_n15_p0.1 rnnvk_topk${n}_n16_p0.1 rnnvk_topk${n}_n17_p0.1 rnnvk_topk${n}_n18_p0.1 rnnvk_topk${n}_n19_p0.1 rnnvk_topk${n}_n20_p0.1 rnnvk_topk${n}_n21_p0.1 rnnvk_topk${n}_n22_p0.1 rnnvk_topk${n}_n23_p0.1 rnnvk_topk${n}_n2_p0.1 rnnvk_topk${n}_n3_p0.1 rnnvk_topk${n}_n4_p0.1 rnnvk_topk${n}_n5_p0.1 rnnvk_topk${n}_n6_p0.1 rnnvk_topk${n}_n7_p0.1 rnnvk_topk${n}_n8_p0.1 rnnvk_topk${n}_n9_p0.1; do #rnn5_p0.011 rnn5_p0.011 rnnvk_topk${n}_p0.1 rnnvk_topk${n}_p0.1.w0.7 rnnvk_topk${n}_p0.1.w0.9 rnnvk_topk${n}_p0.1.w0.95 ; do #rnnvk_topk${n}_p0.1; do #rnnvk_topk${n}_p0.001 rnnvk_topk${n}_p0.001.w0.7 rnnvk_topk${n}_p0.001.w0.9 rnnvk_topk${n}_p0.001.w0.95 rnnvk_topk${n}_p0.01 rnnvk_topk${n}_p0.01.w0.7 rnnvk_topk${n}_p0.01.w0.9 rnnvk_topk${n}_p0.01.w0.95 rnnvk_topk${n}_p0.1 rnnvk_topk${n}_p0.1.w0.7 rnnvk_topk${n}_p0.1.w0.9 rnnvk_topk${n}_p0.1.w0.95 rnnvk_topk${n}_p0.001 rnnvk_topk${n}_p0.01 rnnvk_topk${n}_p0.1 oo
  decode_dir="/scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_${model_id}_${lm}"
  val=$(cat ${decode_dir}/char_kws_*/metrics.txt | grep ${metric} | awk -v C=$col '{print $C}' | sort -nr | head -n1)
  order=$(echo $lm | cut -f3 -d'_' | tr -d 'n')
  echo "$order $val" >> data/results/rnnvk_topk${n}_mtwv.tmp
done
sort -nk1 data/results/rnnvk_topk${n}_mtwv.tmp > data/results/rnnvk_topk${n}_mtwv.dat
rm data/results/rnnvk_topk${n}_mtwv.tmp
done
