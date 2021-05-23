
# tab.gold

Holder for rows, summarized into cols.
@include "ako"

```awk
function Tab(i, a) {
  Obj(i)
  is(i, "Tab")
  has(i,"rows")
  has(i,"cols")
  for(j in a) add(i, a[j] }
function _Add(i, a) {
  if (length(a)) {
    if ("is" in a && a.is=="Row") 
      _Add(i,a.cells)
    else 
      length(i.cols) ?  moRE(i.rows, "Row", a,i) : haS(i,"Cols",a) }}
function _Clone(i, j, rows) {
  Tab(j, i.names)
  for(r in rows)
    add(j, rows[r]) }
function Cols(i,a,    txt) {
  Obj(i)
  is(i,"Cols")
  i.klass = ""
  has(i,"x")
  has(i,"y")
  has(i,"all")
  has(i,"names")
  for(at in a) {
    txt = a[at]
    i.names[at] = txt
    hAS(i.all, at, isWhat(txt), at, txt)
    if (isSkip(txt)) return
    isY(txt) ? i.y[at] : i.x[at]
    if isKlass(txt) i.klass = at } }
function Row(i,a, tab) {
  Obj(i)
  is(i,"Row")
  for(j in a) add(tab.cols.all[j], a[j]) }
function  _Dist(i,j,tab,cols,p,     k,n,d) {
  if (!length(cols))  
    return  _Dist(i,j,tab,tab.cols.x,p)
  p = p ? p : 2
  for(k in cols) {
    n+=1
    d+= dist(tab.cols.all[k], i.cells[k], j.cells[k] )^p }
  return (d/p)^(1/p) }
```
