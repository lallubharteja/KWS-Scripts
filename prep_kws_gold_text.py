#!/usr/bin/env python3

import logging
import sys
import os

def parse_name(utype):
    parts = utype.split('_')
    stype = parts[0]
    btype = parts[1]
    return stype,btype

def main(text, utype):
    stype, btype = parse_name(utype)
    parent_dir = os.path.dirname(text)
    base = os.path.basename(text) 
    
    word_map = os.path.join(parent_dir, stype, base + '.wordmap')
    allowed_chars = {line.strip() for line in open(os.path.join(parent_dir, 'allowed_chars'), encoding='utf-8') if len(line.strip()) == 1}

    between = " "
    prefix = ""
    suffix = ""
   
    assert btype in {"aff", "wma", "suf", "pre", "word"}
    if btype == "wma":
        between = " <w> "
    if btype == "pre" or btype == "aff":
        prefix ="+"
    if btype == "suf" or btype == "aff":
        suffix ="+"
    

    m = {}
    for line in open(word_map, encoding='utf-8'):
        parts = line.strip().split()
        if stype == "char":
            parts_filtered = [c if c in allowed_chars else '<UNK>' for c in parts[1:]]
            m[parts[0]] = "{} {}".format(suffix,prefix).join(parts_filtered).replace("+<unk>","<unk>").replace("<unk>+", "<unk>").replace("+<UNK>","<UNK>").replace("<UNK>+", "<UNK>").replace("<unk>", "<UNK>")
        else:
            m[parts[0]] = " ".join(parts[1:]).replace("+<unk>","<unk>").replace("<unk>+", "<unk>").replace("+<UNK>","<UNK>").replace("<UNK>+", "<UNK>").replace("<unk>", "<UNK>") 
        if "<UNK>" in m[parts[0]]:
            m[parts[0]] = "<UNK>"

    outfile = os.path.join(parent_dir, stype, 'text_only')
    with open(outfile, 'w', encoding='utf-8') as outf:
        for line in open(text, 'rt', encoding='utf-8'):
            parts = line.strip().split()
            for p in parts:
                if p not in m:
                    m[p] = "<UNK>"
            new_line = between + between.join(m[p] for p in parts) + between
            new_line = new_line.strip()
            print(new_line.strip(), file=outf)
            

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main(sys.argv[1], sys.argv[2])
