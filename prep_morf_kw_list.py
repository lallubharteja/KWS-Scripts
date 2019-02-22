#!/usr/bin/env python3 

from __future__ import print_function

import morfessor
import sys
import collections
import logging
import lzma
import os
import math

def main(oov_file, btype, model):
    parent_dir = os.path.dirname(oov_file)

    allowed_chars = {line.strip() for line in open(os.path.join(parent_dir, 'allowed_chars'), encoding='utf-8') if len(line.strip()) == 1}
    
    model = morfessor.MorfessorIO().read_any_model(model)

    between = " "
    prefix = ""
    suffix = ""

    assert btype in {"aff", "wma", "suf", "pre"}
    if btype == "wma":
        between = " <w> "
    if btype == "pre" or btype == "aff":
        prefix ="+"
    if btype == "suf" or btype == "aff":
        suffix ="+"

    for line in open(oov_file, encoding='utf-8'):
        word = line.strip()
        parts = model.viterbi_segment(word)[0]
        rparts = []
        for p in parts:
            if not all(c in allowed_chars for c in p):
                p = '<UNK>'
            rparts.append(p)
        
        print("{} {}".format(suffix,prefix).join(rparts).replace("+<unk>","<unk>").replace("<unk>+", "<unk>").replace("+<UNK>","<UNK>").replace("<UNK>+", "<UNK>").replace("<unk>", "<UNK>"))

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    if len(sys.argv) != 4:
        print("%d arguments passes" % len(sys.argv))
        print("usage: python3 prep_morf_kw_list.py <oov-file> <boundary-type> <morfessor-model>")
        print("e.g.: python3 prep_morf_kw_list.py data/kws_prep/oov.list aff data/kws_prep/morf/model.bin > data/kws_prep/morf/kwlist_aff.txt")
        print("This script converts a word to morpheme sequences and append affixes as specified.")
        print("And then prints this sequence to stdout.")
        sys.exit(-1)
    main(sys.argv[1],sys.argv[2],sys.argv[3])

