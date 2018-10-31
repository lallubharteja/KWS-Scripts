cut -f2,7 -d'|' /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_morfessor_f2_a0.05_tokens_aff_v/morf_kws_10/bsum.txt | tail -n+19 | head -n-3 | grep -v "+-+" | tr -d ' ' | tr '|' ' ' | awk -F'++' 'NF{ print $0, NF}' | awk '{if (length($2) > 1) { if ($3 < 2.1) { k13=k13+1;sum13=sum13+$2; } else {k=k+1;sum=sum+$2} k1=k1+1; mean=mean + $3}} END { print sum13/k13,k13,sum/k,mean/k1}'

cut -f2,7 -d'|' /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_morfessor_f2_a0.05_tokens_aff_v/morf_kws_10/bsum.txt | tail -n+19 | head -n-3 | grep -v "+-+" | tr -d ' ' | tr '|' ' ' | awk -F'++' 'NF{ print $0, NF}' | awk '{if (length($2) > 1) { print $3, $2}}' > data/icassp2019/morf_v.dat

awk '{ for(i=2;i<=NF;i++) {id[$1]=$1; record[$1,i-1]+=$i; c[$1,i-1]+=1}; } END { PROCINFO["sorted_in"]="@ind_num_asc"; for(i in id){ printf("%s\t",i);for(j=1;j<2;j++) if (c[i,j] > -1) {printf("%s\t",record[i,j]/c[i,j]);} printf("\n");} } ' data/icassp2019/morf_v.dat > data/icassp2019/morf_v_atwv.dat

cut -f2,7 -d'|' /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_morfessor_f2_a0.05_tokens_aff_lin.knv.rnnvk_sami.p0.1.w0.5/morf_kws_11/bsum.txt | tail -n+19 | head -n-3 | grep -v "+-+" | tr -d ' ' | tr '|' ' ' | awk -F'++' 'NF{ print $0, NF}' | awk '{if (length($2) > 1) { if ($3 < 2.1) { k13=k13+1;sum13=sum13+$2; } else {k=k+1;sum=sum+$2} k1=k1+1; mean=mean + $3}} END { print sum13/k13,k13,sum/k,mean/k1}'

cut -f2,7 -d'|' /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_morfessor_f2_a0.05_tokens_aff_lin.knv.rnnvk_sami.p0.1.w0.5/morf_kws_11/bsum.txt | tail -n+19 | head -n-3 | grep -v "+-+" | tr -d ' ' | tr '|' ' ' | awk -F'++' 'NF{ print $0, NF}' | awk '{if (length($2) > 1) { print $3, $2}}' > data/icassp2019/morf_lin.knv.rnnv.dat

awk '{ for(i=2;i<=NF;i++) {id[$1]=$1; record[$1,i-1]+=$i; c[$1,i-1]+=1}; } END { PROCINFO["sorted_in"]="@ind_num_asc"; for(i in id){ printf("%s\t",i);for(j=1;j<2;j++) if (c[i,j] > -1) {printf("%s\t",record[i,j]/c[i,j]);} printf("\n");} } ' data/icassp2019/morf_lin.knv.rnnv.dat > data/icassp2019/morf_lin.knv.rnnv_atwv.dat

cut -f2,7 -d'|' /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_v/kws_8.bak/bsum.txt | tail -n+19 | head -n-3 | grep -v "+-+" | tr -d ' ' | tr -d '+' | tr '|' ' ' | awk '{ if (length($2)> 1) { if (length($1) < 13) { k13=k13+1;sum13=sum13+$2; } else {k=k+1;sum=sum+$2} }} END { print sum13/k13,k13,sum/k,k}'

cut -f2,7 -d'|' /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_v/kws_8.bak/bsum.txt | tail -n+19 | head -n-3 | grep -v "+-+" | tr -d ' ' | tr -d '+' | tr '|' ' ' | awk '{ if (length($2)> 1) {print length($1), $2}}' > data/icassp2019/char_v.dat

awk '{ for(i=2;i<=NF;i++) {id[$1]=$1; record[$1,i-1]+=$i; c[$1,i-1]+=1}; } END { PROCINFO["sorted_in"]="@ind_num_asc"; for(i in id){ printf("%s\t",i);for(j=1;j<2;j++) if (c[i,j] > -1) {printf("%s\t",record[i,j]/c[i,j]);} printf("\n");} } ' data/icassp2019/char_v.dat > data/icassp2019/char_v_atwv.dat


cut -f2,7 -d'|' /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_lin.knv.rnnvk_sami.p0.1.w0.5/kws_8/bsum.txt | tail -n+19 | head -n-3 | grep -v "+-+" | tr -d ' ' | tr -d '+' | tr '|' ' ' | awk '{ if (length($2)> 1) { if (length($1) < 13) { k13=k13+1;sum13=sum13+$2; } else {k=k+1;sum=sum+$2} k1=k1+1; mean=mean + length($1)}} END { print sum13/k13,k13,sum/k,k,mean/k1}'

cut -f2,7 -d'|' /scratch/elec/puhe/p/singhm2/rw-fin-2018/lms/exp/decode_yle-dev-new_chars_aff_lin.knv.rnnvk_sami.p0.1.w0.5/kws_8/bsum.txt | tail -n+19 | head -n-3 | grep -v "+-+" | tr -d ' ' | tr -d '+' | tr '|' ' ' | awk '{ if (length($2)> 1) {print length($1), $2}}' > data/icassp2019/char_lin.knv.rnnv.dat

awk '{ for(i=2;i<=NF;i++) {id[$1]=$1; record[$1,i-1]+=$i; c[$1,i-1]+=1}; } END { PROCINFO["sorted_in"]="@ind_num_asc"; for(i in id){ printf("%s\t",i);for(j=1;j<2;j++) if (c[i,j] > -1) {printf("%s\t",record[i,j]/c[i,j]);} printf("\n");} } ' data/icassp2019/char_lin.knv.rnnv.dat > data/icassp2019/char_lin.knv.rnnv_atwv.dat
