
# sym.gold


@include "col"

```awk
function Sym(i,at,txt) {
  Col(i,at,txt)
  is(i,"Sym")
  has(i,"seen")
  i.most = 0
  i.mode = "" }

function _Add(i,x) {
  i.seen[x] = (x in i.seen ? i.seen[x] : 0) + 1
  if (i.seen[x] > i.most) {
    i.most = i.seen[x]
    i.mode = x } }

function _Spread(i) { return _Entropy(i)  }
function _Mid(i)    { return i.mode }

function _Dist(i,x,y) { return x==y ? 0 : 1 }

function _Entropy(i,   e,k,p) {
  for (k in i.seen) {
    p  = i.seen[k]/i.n
    e -= p * log(p)/log(2) }
  return e }
```
