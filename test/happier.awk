# vim: filetype=awk ts=2 sw=2 sts=2  et :

@include "happy"

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        main("happy")
        rogues() }

function main(f,  i) {
  Happy(i)
  read(i, data(f))
  HappyAndYouKnowIt(i) }

function data(f,  d) { 
  d=Gold.dot
  return d d "/data/" f d "csv" }
