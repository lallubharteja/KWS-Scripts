#!/usr/bin/env python3 

from __future__ import print_function

import morfessor
import sys
import collections
import logging
import lzma
import os
import math

def main(allowed_chars_file, model):

    allowed_chars = {line.strip() for line in open(allowed_chars_file, encoding='utf-8') if len(line.strip()) == 1}

    model = morfessor.MorfessorIO().read_any_model(model)

    for line in sys.stdin:
        word = line.strip()
        parts = model.viterbi_segment(word)[0]
        print(word,end=' ')
        print(" ".join(parts).replace("<unk>", "<UNK>"))

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main(sys.argv[1],sys.argv[2])
