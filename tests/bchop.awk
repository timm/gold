function Some(i) {
  Obj(i); is(i,"Some")
  i.n=0
  i.max=40
  has(i,"all") }

function _Add(i,v, pos) {
  if (v == "?") return
  i.n++
  if (i.n < i.max) {
    i.all[ length(i.all)+1 ] = v
    i.ready=0
  } else if (i.n == i.max)  {
    i.all[i.n] = v
    _Ready(i) 
  } else if (rand() < i.max/i.n) {
    if (v< i.all[1] || v>i.all[i.max]) {
      i.all[ 1+int(rand()* length(i.all)) ] = v
      i.ready=0
    } else 
      i.all[ binChop(i.all,v) ] = v }
  return v }

function _Ready(i) { if(!i.ready) { i.ready=asort(i.all) }}

function binChop(a,x,           y,lo, hi,mid)  {
  lo = 1
  hi = length(a)
  while (lo <= hi)  {
    mid = int((hi + lo) / 2)
    y = a[mid]
    if (x == y) break
    if (x <  y) {hi=mid-1} else {lo=mid+1}}
  return mid }

function main(i,s) {
  Some(s)
  for(i=1;i<=100000;i++) {
     if(!(i%100)) SomeReady(s)
     SomeAdd(s,rand()) } 
  SomeReady(s)
  print(length(s.all))
  for(i in s.all) print i,": ["s.all[i]"]" 
}
function main1(i,a,j) {
  for(j=1;j<=100000;j++) a[1+int(30*rand())]= rand()
  asort(a)
  for(j in a) print j,a[j] }

BEGIN {
  R=ENVIRON["R"]
  srand(R?R:1)
  main()
  rogues()
  print(R)
}
