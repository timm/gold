#  ranges.gold

<small>


</small>



-----------------------------------------------
Discrete ranges
 
Copyright (c) 2020, Tim Menzies.  Licensed under the MIT license.
For full license info, see LICENSE.md in the project root

-----------------------------------------------

@include "lib"   
@include "col"   
@include "rows"

-----------------------------------------------------------

Range
Constructor
Return bin size. Forbid sizes less than 4 or more than half.

<ul><details><summary><tt>Range(i:untyped, rs:Rows, c:posint, out:untyped)</tt></summary>

```awk
function Range(i:untyped,rs:Rows,c:posint,out:untyped,   as,lo,s,ho,x,y) {
  Object(i)
  i.is    = "Range"
  i.sample = 128
  i.small = 0.5
  i.col   = c
  i.small = _Size(i,rs)
  as       = _Some(i,rs,a)
  lo      = 1
  List(out)
  s = new(out,"Sym")
  for(hi=1; hi<=as; hi++) {
    x = a[hi].x
    y = a[hi].y
    add(out[s], y)
    if (hi - lo >= i.small)
     if (as - hi >= i.small) 
       if (x != a[hi+1].x ) {
         out[s].cut = x
         s  = new(out, "Sym")
         lo = hi  }}
  return length(out) }
      
function _Size(i,rs,   m,n) {
  n = length(rs.rows)
  m = n^i.small 
  while(m < 4 && m < n/2) m *= 1.2
  return m }    
```

</details></ul>

_Merge

<ul><details><summary><tt>_Merge()</tt></summary>

```awk
function _Merge(i,a,out,   j,b,both) {
  j=1
  while(j <= length(a)) {
    if ( j < length(a)  && _Better(a[j], a[j+1], both)) {
      both.cut = a[j+1].cut
      copy2end(b, both)
      j += 2
    } else { 
      copy2end(b, a[j]) 
      j += 1
  }}
  return length(b) < length(a) ? _Merge(i,b,out) : copy(b,out)}
```

</details></ul>
