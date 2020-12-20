
# vim: filetype=awk ts=2 sw=2 sts=2  et :

@include "scale"

function x(i,at,   f) {f=i.is"X"; return @f(i,at) }
function y(i,      f) {f=i.is"Y"; return @f(i) }

function RowX(i,at) { return i.cells[at] }
function RowY(i) { return i.y }

function div2(lst1,lst4, max,at,eps,min,goal,
              lst2,lst3) {
  print(1)
  div2gather(max/length(lst1),lst1,lst2,max,at) 
  print(2)
  div2split(lst2,lst3,eps,min,goal) 
  print(3)
  div2merge(lst3, lst4); print(4) }   

function div2mid(a,lo,hi) { 
  lo = lo ? lo : 1
  hi = hi ? hi : length(a)
  return a[ int(.5*length(a)) ].x }

function div2sd(a,  n) { 
  n = length(a)
  return (a[int(.9*n)].x - a[int(.1*n)].x) / 2.56 }

function div2gather(p,lst1,lst2,max,at,    j,v,n) {
  split("",lst2,"")
  for(j in lst1) 
    if(rand() < p) {
      v = x(lst1[j],at)
      if(v != "?") {
        n = length(lst2) + 1
        lst2[n].x = v
        lst2[n].y = y(lst1[j])  }}
  keysort(lst2,"x") }

function div2split(lst2,lst3,eps,min,goal,   
                   y,b,n,lo,hi,b4,len,merge,all) {
  eps = div2sd(lst2)*eps
  len = length(lst2)
  n   = len^min
  while(n < 4 && n < len/2) n *= 1.2
  n   = int(n)
  lo  = all = 1
  b4  = ""
  lst3[all].x = lst2[lo].x
  for(hi=n; hi <= n; hi++) {
    if (hi - lo > n) 
      if (hi <= len - n)
        if (lst2[hi].x != lst2[hi+1].x)  
          if ((lst2[hi].x - lst2[lo].x) >= eps)  
            if (b4=="" || ( div2mid(lst2,lo,hi) - b4) >= eps) {
              lst3[ ++all ].x = lst2[hi].x
              b4 = div2mid(lst2,lo,hi)
              lo = hi }
    lst3[all].n++
    y = lst2[hi].y 
    y = goal=="" ? y : y==goal
    lst3[all].y[ y ]++ }}
     
function div2merge(b4,out,    n,j,new,tmp) {
  n= length(b4)
  j= 1
  while(j<=n) {
    if (j<n &&  div2merge1(b4[j], b4[j+1], new)) {
      append(tmp,new)
      j += 2 
    } else {
      oo(b4[j])
      append(tmp, b4[j])
      j += 1 }}
  length(tmp) < n ? div2merge(tmp,out) : copy(b4,out) }

function div2merge1(one,two,three,x,e1,e2,e3) {
  delete three
  copy(one,three)
  three.x = min(one.x,two.x)
  for(x in two) three[x] += two[x]
  three.n = one.n + two.n
  e1      = ent(one.y,   one.n)
  e2      = ent(two.y,   two.n)
  e3      = ent(three.y, three.n)
  return (e1*one.n + e2*two.n)/three.n < e3 }

function main(f,    i,order,bins) {
  Tab(i)
  TabRead(i,data(f ? f : "weather") )
  TabDom(i)
  div2(i.rows, bins, 128, 3, .35, .5)
  oo(bins,":3:")}

function data(f) { return Gold.dots "/data/" f Gold.dot "csv" }

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        main("auto93")
        rogues()  }

