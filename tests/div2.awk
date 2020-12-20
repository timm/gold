
# vim: filetype=awk ts=2 sw=2 sts=2  et :

@include "scale"

function x(i,at,   f) {f=i.is"X"; return @f(i,at) }
function y(i,      f) {f=i.is"Y"; return @f(i) }

function RowX(i,at) { return i.cells[at] }
function RowY(i) { return i.y }

function div2(lst1,lst4, max,at,eps,min,goal,
              lst2,lst3) {
  div2gather(max/length(lst1),lst1,lst2,max,at) 
  div2split(lst2,lst3,eps,min,goal) 
  print(length(lst3))
  div2merge(lst3, lst4)  }   

function div2mid(a,lo,hi) { 
  lo = lo ? lo : 1
  hi = hi ? hi : length(a)
  return a[ int(lo + .5*(hi-lo)) ].x }

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
  for(hi=1; hi <= len; hi++) {
    if (hi - lo > n) 
      if (hi <= len - n)
        if (lst2[hi].x != lst2[hi+1].x)  {
            if (all==1 || ( div2mid(lst2,lo,hi) - b4) >= eps) {
              lst3[ ++all ].x = lst2[hi].x
              b4 = div2mid(lst2,lo,hi)
              lo = hi }}
    lst3[all].n++
    y = lst2[hi].y 
    y = goal=="" ? y : (y==goal ? goal : -1*goal)
    lst3[all].y[ y ]++ }}
     
function div2merge(b4,out,    shorter,n1,n2,j,now,tmp) {
  n1= length(b4)
  j= 1
  while(j <= n1) {
    new(tmp,++n2)
    if (j < n1)
      if(div2merge1(b4[j], b4[j+1], now)) {
        copy(now, tmp[n2])
        shorter++ 
        j += 2 
        continue }
    copy(b4[j], tmp[n2])
    j += 1 }
  shorter ? div2merge(tmp,out) : copy(b4,out) }

function div2merge1(one,two,three,    y,e1,e2,e3) {
  delete three
  copy(one,three)
  three.x = max(one.x,two.x)
  for(y in two.y) three.y[y] += two.y[y]
  three.n = one.n + two.n
  e1      = ent(one.y,   one.n)
  e2      = ent(two.y,   two.n)
  e3      = ent(three.y, three.n)
  #print(o(one.y) "|",o(two.y) "|", one.n, two.n, three.n, "e1",e1,"e2",e2,"e3",e3)
  return (e1*one.n + e2*two.n)/three.n <= e3*.95 }

function main(f,    i,c,bins,goal) {
  Tab(i)
  TabRead(i,data(f ? f : "weather") )
  goal=TabDom(i)
  print("goal",goal)
  for(c in i.cols)
    if(i.cols[c].is=="Some") {
      div2(i.rows, bins, 128, i.cols[c].pos, .2, .5,goal)
      print("=============")
      oo(bins,":"i.cols[c].pos)}}

function data(f) { return Gold.dots "/data/" f Gold.dot "csv" }

BEGIN { srand(Gold.seed ? Gold.seed : 1) 
        main("auto93")
        rogues()  }

