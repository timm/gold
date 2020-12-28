# vim: filetype=awk ts=2 sw=2 sts=2  et :

#<
SCALE: StoChAstic LandscapE analysis
(c) 2020 MIT License, Tim Menzies timm@ieee.org
Optimization via discretization and contrast sets.

def. scale (v):
-   To climb up or reach by means of a ladder;
-   To attack with or take by means of scaling ladders;
-   To reach the highest point of (see also SURMOUNT)

                              Hooray!   .
                                 -. _ O /
                                     _ '
                                    / \
                                    ())
         _ _      _..--.. .-' _-.     .-d-b-.
     --'   _ _.-'        _ _.. _.  _  .'        _.   _.
        .-'                  a:f          ,-'
#>

BEGIN {   
  Gold.scale.Tab.samples = 64
  Gold.scale.Some.div.min = 0.5
  Gold.scale.Some.div.epsilon = 0.35
}

### shortcuts
function add(i,x,  f) { f=does(i,"Add"); return @f(i,x) }
function discretize(i,x,  f) { f=does(i,"Discretize"); return @f(i,x) }

### columns
## generic column
function Col(i,pos,txt) {
  Obj(i)
  is(i, "Col")
  i.pos=pos
  i.txt=txt
  i.n  =0
  i.w  =txt ~ /</ ? -1 : 1 }

## columns whose data we will ignore
function Skip(i,pos,txt) { Col(i,pos,txt); is(i,"Skip") }
function _Add(i,x)       { return x }

## columns of symbols which we will summaries
function Sym(i,pos,txt) {
  Col(i, pos,txt)
  is(i,  "Sym")
  has(i,"seen")
  has(i,"bins")
  i.mode=i.most="" }

function _Add(i,x,    d,n) {
  if (x!="?") {
    i.n++
    n = ++i.seen[x]
    if(n>i.most) { i.most=n; i.mode=x} }
  return x }

function _Discretize(i,x) { if(x!="?") return x }

function _Ent(i,      p,e,x) {
  for(x in i.seen) 
    if((p=i.seen[x] / i.n)>0)
      e -= p*log(p)/log(2);
  return e }

function _Seperate(i,j,k,       ei,ej,both,parts) {
  _Combine(i,j,k) 
  ei = _Ent(i)
  ej = _Ent(j)
  both = _Ent(k)
  parts = (ei*i.n + ej*j.n)/k.n 
  return  abs(both - parts)/both > 0.05 }

##columns of numbers, from which we will keep a sample
function Some(i,pos,txt) {
  Col(i,pos,txt)
  is(i,"Some")
  i.ok= 1
  i.want=128 # number of samples
  i.lo =  1E30
  i.hi = -1E30
  has(i,"bins")
  has(i,"all") }

function _Add(i,x,    len,pos) {
  if (x != "?") {
    i.n++
    len=length(i.all)
    if  (i.n < i.want)   
       pos=len + 1 
    else 
       if (rand() < i.want/i.n) 
         pos=int(len*rand()) ;
    if (pos) {
      if (x < i.lo) i.lo = x
      if (x > i.hi) i.hi = x
      i.ok=0
      i.all[pos]=x }}
  return x }

function _Ok(i) { i.ok = i.ok ? i.ok : asort(i.all) }

function _Mid(i,lo,hi) { return  _Per(i,.5,lo,hi) }

function _Sd(i,lo,hi) {
  return (  _Per(i,.9,lo,hi) -  _Per(i,.1,lo,hi))/2.54 }

function _Per(i,p,lo,hi) { 
   _Ok(i)
  lo = lo?lo:1
  hi = hi?hi:length(i.all)
  return i.all[ int(lo + p*(hi-lo)) ] }

function _Norm(i,x,   n) {
  if (x=="?") return x
  x= (x-i.lo) / (i.hi - i.lo +1E-32)
  return x<0 ? 0 : (x>1 ? 1 : x) }

function _Discretize(i,x,     j) {
  if (x!="?") {
    _Bins(i)
    for(j=1; j<=length(i.bins); j++) 
      if( x<=i.bins[j] ) {x=j; break}
    x=j }
  return x}
     
function _Bins(i,     eps,min,b,n,lo,hi,b4,len,merge) {
  if (!length(i.bins)) {
     _Ok(i)
    eps = Gold.scale.Some.div.epsilon
    min = Gold.scale.Some.div.min
    eps = _Sd(i)*eps
    len = length(i.all)
    n   = len^min
    while(n < 4 && n < len/2) n *= 1.2
    n   = int(n)
    lo  = 1
    b   = b4 = 0
    for(hi=n; hi <= len-n; hi++) {
      if (hi - lo > n) 
        if (i.all[hi] != i.all[hi+1])  
          if ((i.all[hi] - i.all[lo]) >= eps)  
            if (b4==0 || (   _Mid(i,lo,hi) - b4) >= eps) {
              i.bins[++b]   = i.all[hi]
              b4  = _Mid(i,lo,hi)
              lo  = hi
              hi += n }}}}

### rows of data
function Row(i,a,t,     j) {
  Obj(i)
  is(i, "Row")
  i.dom = 0
  has(i,"cells") 
  for(j in a) i.cells[j] = add(t.cols[j], a[j]) }

function _X(i,j) {return i.cells[j] }
function _Y(i)   {return i.y}

function _Dom(i,j,t,   
              n,e,c,w,x,y,sum1,sum2) {
  n = length(t.ys)
  for(c in t.ys) {
    w     = t.cols[c].w
    x     = SomeNorm(t.cols[c], i.cells[c])
    y     = SomeNorm(t.cols[c], j.cells[c])
    sum1 -= 2.71828 ^ ( w * (x - y)/n )
    sum2 -= 2.71828 ^ ( w * (y - x)/n )
  }
 return sum1/n < sum2/n }

### tables store rows, summarized in columns
function Tab(i) {
  Obj(i)
  is(i,"Tab")
  has(i,"xs")
  has(i,"ys")
  has(i,"rows")
  has(i,"cols") }

function _What(i,pos,txt,  x,where) {
  x="Sym"
  if (txt ~ /[<>:]/) x="Some"
  if (txt ~ /\?/)    x="Skip"
  if (x != "Skip") {
    where =  txt ~ /[<>!]/ ? "ys" : "xs"
    i[where][pos] }
  return x }
 
function _Add(i,a,    j) {
  if (length(i.cols)>1) 
    hAS(i.rows, int(1E9 * rand()) ,"Row",a,i)
  else 
    for(j in a)
      hAS(i.cols, j,  _What(i,j,a[j]), j, a[j]) }

function _Dom(i,  n,j,k,s) {
  Some(s)
  for(j in i.rows) {
    n= Gold.scale.Tab.samples
    for(k in i.rows) {
       if(--n<0) break
      if(i.rows[j].id > i.rows[k].id) 
        i.rows[j].dom += RowDom(i.rows[j], i.rows[k],i)}
    add(s,i.rows[j].dom) }
   for(j in i.rows)
      i.rows[j].y = SomeDiscretize(s, i.rows[j].dom)  
   return length(s.bins)+1 }

function _Read(i,f,  a) {  while(csv(a,f)) add(i,a) }  

function Nb(i,cols,rows,     r) {
  has(i,"f")  # counts of symbols in each column for each class
  has(i,"h")  # frequency counts for each class
  has(i,"at") # reverse index, column, symbol to row
  i.k=1
  i.m=2
  i.n = 0
  i.top = 16
  i.repeats=20 
  i.best = -1
  has(i,"ranges")
  for(r in rows) _Adds(i,rows[r],cols) }

function _Adds(i,row,cols,    r,h,c,x) {
  i.n++
  h = RowY(row)
  i.h[h]++
  i.best = max(i.best,h)
  for(c in cols) 
    if(x= discretize(cols[c], RowX(row,c))) 
     if (x != "?") {
       i.at[h][c][x][row.id]
       i.f[h][c][x]++ }}

function _Ranks(i, h) {
  for(h in i.h) 
    if (h!=i.best) _Rank(i,h,i.best) }

function _Rank(i,rest,best,  xs,m,n,a,c,x) {
  split("",a,"")
  for(c in i.f[best])  {
   asort(i.f[best][c],xs)
  _Rank1(i,c,rest,best,a,xs) }}

function _Rank1(i,c,rest,best,a,xs,   n) {
  n= length(xs)
  j=1
  while(j<=n) {
    x = xs[j]
    _Rank2(i,c,x,rest,best,a) }}

# combine

function _Rank2(i,c,x,rest,best,out,    inc,tmp) {
  if (Rule(tmp, i,rest,best,c,x)) append(out,tmp) }

function _Like(i,a,h,   like,prior,inc,c,x,f) {
  like = prior = (i.h[h] + i.k) / (i.n + i.k*length(i.h))
  like = like
  for(c in a) {
    f = 0
    for(x in a[c])
      f += ((x in i.f[h][c]) ? i.f[h][c][x] : 0);
    inc   = (f + i.m*prior)/(i.h[h] + i.m)
    like *= inc
  }
  return like }

function _Learn(i,a,       b4,sum,j,repeats) {
  for(j=length(a)-i.top; j>=1;  j--) 
    delete a[j]
  for(j in a) sum += a[j].n 
  repeats = i.repeats
  while(repeats-- > 0) _Pick2(i,a,sum)
  if(length(a) > i.top)
    _Learn(i,a) }

function _Pick2(i,a,sum,    new,diff,j,k) {
  j = _Pick1(i,a,sum)
  k = _Pick1(i,a,sum)
  if (j != k && RuleMerge(a[j], a[k], new, i)) 
    append(a, new) }

function _Pick1(i,a,sum,   j,r) {
  r = rand()
  for(j=length(a); j>= 1; j--)
    if ((r -= a[j].n/sum) <=0) break
  return j }

function Rule(i,nb,rest,best,c,x,    b,r) { 
  Obj(i); is(i,"Rule") 
  has(i,"has")
  i.has[c][x]
  i.c = c
  i.x = x
  i.from   = rest 
  i.to     = best 
  b        = NbLike(nb, i.has, i.to) 
  r        = NbLike(nb, i.has, i.from) 
  i.n      = b^2/(b+r)
  return b > r }

function _Merge(i,j,k,nb,   c,b,r) {
  copy(i,k)
  for(c in j.has) k.has[c][j.has[c]]
  b        = NbLike(nb, k.has, i.to) 
  r        = NbLike(nb, k.has, i.from) 
  k.n      = b^2/(b+r)
  return (k.n > i.n || k.n > j.n) && b > r }
