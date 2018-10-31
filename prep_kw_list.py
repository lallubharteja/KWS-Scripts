#!/usr/bin/env python3

import logging
import sys
import os

def parse_name(d):
    base = os.path.basename(d)
    assert base.startswith("kwlist")
    parts = base.split('_')
    btype = parts[1]
    return btype

def main(keywords):
    btype = parse_name(keywords)
    d=os.path.dirname(keywords)
    parent_dir = os.path.dirname(d)
    
    allowed_chars = {line.strip() for line in open(os.path.join(parent_dir, 'allowed_chars'), encoding='utf-8') if len(line.strip()) == 1}

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
        word = line.strip().split()
        parts = [c if c in allowed_chars else '<UNK>' for c in word[0]]
        print("{} {}".format(suffix,prefix).join(parts).replace("+<unk>","<unk>").replace("<unk>+", "<unk>").replace("+<UNK>","<UNK>").replace("<UNK>+", "<UNK>").replace("<unk>", "<UNK>"))

           

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main(sys.argv[1])
