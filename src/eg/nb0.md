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
  for(col in i.all.cols) {
    x = row[col]
    i.some[k][col][x]++
    i.all[col][x]++ }
}
    
function nb(file) {
  csv(file, cells) 
  Classes(seem,,cells)  
  while (csv(file,cells))
    if(++n>5)
      ClassesClassify(cells[alxXXX
    ClassesAdd(seen,cells)
}
```
