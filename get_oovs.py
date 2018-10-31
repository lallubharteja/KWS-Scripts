#!/usr/bin/env python3

import sys

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

