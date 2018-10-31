#!/usr/bin/env python3 

from __future__ import print_function

import morfessor
import sys
import collections
import logging
import lzma
import os
import math

def parse_name(d):
    base = os.path.basename(d)
    assert base.startswith("kwlist")
    parts = base.split('_')
    btype = parts[1]
    return btype

def main(keywords, model):
    btype = parse_name(keywords)
    d=os.path.dirname(keywords)
    parent_dir = os.path.dirname(d)

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

    for line in open(os.path.join(parent_dir, 'oov.list'), encoding='utf-8'):
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
    main(sys.argv[1],sys.argv[2])

