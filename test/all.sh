#!/usr/bin/env bash

gawk -W version | head -1
ls 

for i in  *ok.md; do
  bash ../etc/run.sh $i
done  |  gawk ' 
 1                         # a) print current line      
 /FAILED!/ { err += 1 }    # b) catch current error number
 END       { exit err - 1} # c) one test is designed to fail 
                           #    (just to test the test engine)
                           #     so "pass" really means, "only
                           #     one test fails"
 '

out="$?"

echo "Number of problems: $out"

exit $out
