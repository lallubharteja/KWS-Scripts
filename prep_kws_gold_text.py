#!/usr/bin/env python3

import logging
import sys
import os

def main(text, stype, btype):
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
        parts_filtered = []
        if stype == "char":
            parts_filtered = [c if c in allowed_chars else '<UNK>' for c in parts[1:]]
        elif stype == "morf":
            for p in parts[1:]:
                if not all(c in allowed_chars for c in p):
                    p = '<UNK>'
                parts_filtered.append(p)
        else:
            raise Exception("subword {} type not defined.".format(stype))
        
        m[parts[0]] = "{} {}".format(suffix,prefix).join(parts_filtered).replace("+<unk>","<unk>").replace("<unk>+", "<unk>").replace("+<UNK>","<UNK>").replace("<UNK>+", "<UNK>").replace("<unk>", "<UNK>") 
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
    if len(sys.argv) != 4:
        print("usage: python3 prep_kws_gold_text.py <text> <subword-id> <boundary-type-id> ")
        print("e.g.: python3 prep_kws_gold_text.py data/kws_prep/dev.txt char aff")
        print("This script converts a text file to character/morpheme sequences and")
        print("append affixes as specified. And then writes this sequence to a file.")
        print(" at <text-dir>/<subword-id>/text_only.")
        sys.exit(-1)
    main(sys.argv[1], sys.argv[2], sys.argv[3])
