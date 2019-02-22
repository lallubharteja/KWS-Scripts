#!/usr/bin/env python3

import sys

if len(sys.argv) != 3:
    print("usage: python3 get_oovs.py <test-file-vocab> <training-vocab>")
    print("e.g.: python3 get_oovs.py test.voc voc")
    print("prints Out-of-Vocabulary words in input text to stdout")
    sys.exit(-1)

ref=sys.argv[1]
corpusvocab={line.strip() for line in open(sys.argv[2], encoding='utf-8')}

for line in open(ref, encoding='utf-8'):
  words = line.strip().split()
  for word in words:
    if word not in corpusvocab:
      print(word)
