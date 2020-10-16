## Naive Bayes
Basic Naive Bayes

```awk
@include "/../lib/oo"
@include "/../lib/file"
@include "/../stats/abcd"

function Nb(i,file) {
   i.file = file
   i.min = 10
   i.k = 1
   i.m = 2
   i.class = 0
   i.nall = 0
   has(i, "seen")
   has(i, "all")
   has(i, "log", "Abcd") }

function _Classify(i,row,     c,f,fudge,x,y,like,most,out,prior) {
  fudge = i.k * length(i.some)
  for(y in i.some) {
    like = prior = (i.n[y] + i.k)/(i.nall + fudge)
    like = log(like)
    for(c in row)
      if(c != i.class) {
        x = row[c]
        if(x != "?")  {
          f = i.some[y][c][x] 
          like += log( (f + i.m*prior) / (i.n[c] + i.m)) }}
    if (like>most) { 
      most=like; out=y }}
  return out }   

function _Read(i,     row) {
  csv(i.file, row) 
  i.class = length(row)
  while (csv(i.file, row)) {
    _Test(i, row)
    _Train(i,row) }}

function _Test(i,row) {
   if (++i.nall > i.min)
      AbcdAdd(i.log, row[i.class], _Classify(i,row))}

function _Train(i,row,    x,y,c) {
  y = row[i.class]
  i.n[y]++
  for(c in row) {
    x = row[c]
    if(x != "?") {
      i.some[y][c][x]++
      i.all[c][x]++  }}}

  
```
