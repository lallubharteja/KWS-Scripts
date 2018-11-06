#!/usr/bin/env python3

import sys

if len(sys.argv) != 2:
    print("usage: python3 get_oovs.py <test-file> <training-vocab>")
    print("e.g.: python3 get_oovs.py dev.txt voc")
    print("prints Out-of-Vocabulary words in input text to stdout")
    sys.exit(-1)

ref=sys.argv[1]
corpusvocab={line.strip() for line in open(sys.argv[2], encoding='utf-8')}

total = 0
oovs = 0

for line in open(ref, encoding='utf-8'):
  word = line.strip()
  total += 1
  if word not in corpusvocab:
    oovs += 1
    print(word)
print("%d %d %f" % (total, oovs, oovs/total),file=sys.stderr)

