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
    hasss(i.cols,j,"Sym",txt, pos) }
}
function _Clone(i,j) { Rows(i, j.head) }

function Classes(i) {
  has(i,"all","Rows")
  has(i,"some") 
  has(i,"log","Abcd") 
}
function _Add(i,row) {
  k = row[i.class]
  if (! (k in i.some))
    has(i.some,k,"RowsClone",i.all);
  for(c in i.all.cols) {
    x = row[x]
    i.some[k][c][x]++
    i.all[c][x]++ }
}
    
function nb(file) {
  csv(file, cells) 
  Classes(all,cells)  
  while (csv(file,cells))
    if(++n>5)
      ClassesClassify(cells[al
    ClassesAdd(all,cells)
}
```
