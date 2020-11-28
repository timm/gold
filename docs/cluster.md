#  cluster.gold
  - [Cluster](/docs/cluster.md#cluster) : Recursively split the data using two distant points.
    - [Cluster](/docs/cluster.md#cluster) : Constructor for a tree of clusters
    - [_Div](/docs/cluster.md#_div) : Divide the data 
    - [_Project](/docs/cluster.md#_project) : Return how far `r` falls between `i.lo` and `i.hi`. 
    - [_Print](/docs/cluster.md#_print)


-----------------------------------------------------------

## Cluster
Recursively split the data using two distant points.

-----------------------------------------------------------

@include "lib"
@include "rows"

### Cluster
Constructor for a tree of clusters

<ul><details><summary><tt>Cluster(i:untyped, rs:rows, top:array, lvl:posint, a:array|)</tt></summary>

```awk
function Cluster(i:untyped,rs:rows,top:array,lvl:posint,a:array|) {
  Object(i)
  i.is = "Cluster"
  i.enough=16
  i.lvl = lvl ? lvl : 0
  i.c = i.lo = i.hi = i.mid = ""
  has(i,"leaves")
  has(i,"upper")
  has(i,"lower") 
  if ( lvl>0)
    _Div(i,rs,a,top)
  else {
    _Div(i,rs,rs.rows, i.leaves) }}
```

</details></ul>

### _Div
Divide the data 

<ul><details><summary><tt>_Div(i:Cluster, rs:rs, a:array, top:array)</tt></summary>

```awk
function _Div(i:Cluster,rs:rs,a:array,top:array,     r,b,n,lt,gt) {
  for(r in a) break # r is the first item
  i.lo = RowsFar(rs,  r)
  i.hi = RowsFar(rs,  i.lo)
  i.c  = RowsDist(rs, i.lo, i.hi)
  for(r in a) {
    b[r].row = r
    b[r].x   = _Project(i,rs,r)
  }
  n = keysort(b,"x")
  i.mid = b[int(n/2)].x
  if (length(b) < 2*i.enough)  
    i.about = RowsSomeBins(rs, a, top)
  else { 
    for (r in b) 
      b[r].x  <= i.mid ? lt[ b[r].row ] : gt[ b[r].row ]
    HASS(i, "upper", "Cluster", rs, top, i.lvl+1, lt)
    HASS(i, "lower", "Cluster", rs, top, i.lvl+1, gt) }}
```

</details></ul>

### _Project
Return how far `r` falls between `i.lo` and `i.hi`. 

<ul><details><summary><tt>_Project(i:Cluster, rs:Rows, r:posint)</tt></summary>

```awk
function _Project(i:Cluster, rs:Rows, r:posint,    a,b,x) {
   a = RowsDist(rs,r,i.lo)
   b = RowsDist(rs,r,i.hi)
   x = (a^2 + i.c^2 - b^2)/(2*i.c)
   return max(0, min(1, x)) }
```

</details></ul>

### _Print

<ul><details><summary><tt>_Print(i:Cluster)</tt></summary>

```awk
function _Print(i:Cluster,         lvl,pre,d) {
   # Recursively print a trees
   d = Gold.dot
   print pre length(i.has)
   if (length(i.lower)) _Print(i.lower, lvl+1, "|" d d " " pre)
   if (length(i.upper)) _Print(i.upper, lvl+1, "|" d d " " pre) }
```

</details></ul>
