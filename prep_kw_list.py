#!/usr/bin/env python3

import logging
import sys
import os

def main(oov_file, btype):
    parent_dir = os.path.dirname(oov_file)
    
    allowed_chars = {line.strip() for line in open(os.path.join(parent_dir, 'allowed_chars'), encoding='utf-8') if len(line.strip()) == 1}

    prefix = ""
    suffix = ""
   
    assert btype in {"aff", "wma", "suf", "pre"}
    if btype == "pre" or btype == "aff":
        prefix ="+"
    if btype == "suf" or btype == "aff":
        suffix ="+"

    for line in open(oov_file, encoding='utf-8'):
        word = line.strip().split()
        parts = [c if c in allowed_chars else '<UNK>' for c in word[0]]
        print("{} {}".format(suffix,prefix).join(parts).replace("+<unk>","<unk>").replace("<unk>+", "<unk>").replace("+<UNK>","<UNK>").replace("<UNK>+", "<UNK>").replace("<unk>", "<UNK>"))

           

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    if len(sys.argv) != 3:
        print("usage: python3 prep_kw_list.py <oov-file> <boundary-type> ")
        print("e.g.: python3 prep_kw_list.py data/kws_prep/oov.list aff > data/kws_prep/dev.words")
        print("This script converts a word to character sequences and append affixes as specified.")
        print("And then prints this sequence to stdout.")
        sys.exit(-1) 
    main(sys.argv[1], sys.argv[2])
