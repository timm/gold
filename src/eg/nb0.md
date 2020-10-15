## Naive Bayes
Basic Naive Bayes

```awk
@include "/../lib/oo"
@include "/../lib/file"
@include "/../stats/abcd"

function Syn(i,pos,txt) {
  i.pos=pos
  i.txt=txt
  has(i,seen)
}
function Rows(i,head) {
  Obj(i)
  has(i,"cols")
  has(i,"header")
  for(pos in head) {
    txt = i.head[pos] = head[pos]
    if (txt ~ /!/) i.class=pos
    hasss(i.cols,j,"Sym",txt, pos)
  }
}
function RowsAdd(i,a) { for(c in i.cols) i.seen[c][a[c]]++}
function RowsFrom(i,j) { Rows(i, j.head) }

function Nb(i,file) {
  i.file = file
  has(i,"all","Rows")
  has(i,"classes") }

function NbAdd(i,row) {
  k = row[i.class]
  NbKnown(i, k)
  NbAdd(i.all,        row)
  NbAdd(i.classes[k], row)
}

function _Next(i,a) { 
  if(csv(i.file,a)) {
    k = a[i.class]
    if(! (k in classes)) 
      has(classes,k,"RowsFrom", i.all) 
    return k }}
    
function nb(file) {
  Abcd(log)
  csv(file, cells) {
  Rows(all,cells)  
  while RowsNext(all,cells) {
    n++
    NbAdd(all,cell)

    
  }
}
```
