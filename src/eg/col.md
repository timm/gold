## Col
Incrementally summarize columns

### class Some
Reservoir sampling: just keep up to `i.max` items.

#### Some
Initialize

```awk
function Some(i) { 
  i.is="Some"; i.sorted=0; 
  i.Size = 0.5
  i.Small = 4
  i.Epsilon = 0.01
  has(i,"all"); i.n=0; i.max=256 }
```

#### Some
Add a new item (if reservoir not full). Else, replace an old item.

```awk
@include "/../lib/list" # get "any"

func _Add((i,x) {
  if (x=="?") return x
  if (length(i.all) < i.max)     return i.all[1+length(i.all)]=x
  if (rand()        < i.max/i.n) return i.all[     any(i.all)]=x }

func _Sd(i,lo,hi,   p10,p90) {
  if(!sorted) i.sorted=asort(i.all)
  p10 = int(0.5 + (hi - lo)*.1)
  p90 = int(0.5 + (hi - lo)*.9)
  return (i.all[p90] - i.all[p10])/2.56 }

func _Better(i,a,b,c,     sd0,sd1,sd2,sd12,n1,n2) {
  n1   = b-a
  n2   = c-b-1
  sd0  = _Sd(i,a,c)
  sd1  = _Sd(i,a,b)
  sd2  = _Sd(i,b+1,c)
  sd12 = n1/(n1+n2) * sd1 + n2/(n1+n2) * sd2
  return sd0 - sd12 > i.Epsilon }

function _Div(i,bins,    n0,n1,lo,hi,bins,b) {
  if(!sorted) i.sorted=asort(i.all)
  l = length(i.all)
  m = l^i.Size
  while(m < i.Small &&  m < l/2) m *= 1.2
  b4 = alls = as = 1
  a[as].lo = a[as].hi = 1
  while(++alls <= l) {
    if(alls - b4 > m) 
      if(i.all[alls] != i.all[alls-1]) 
        b4 = a[++as].lo = a[as].hi = alls 
    a[as].hi = alls
  }  
  _Merge(i,a) }

func _Merge(i,a,c,    amax,as,b,bs) {
  amax = length(a)
  as = bs = 1
  b[bs].lo = a[as].lo
  b[bs].hi = a[as].hi
  while(as <= amax) {
    if(as < amax && _Better(i, a[as].lo, a[as].hi, a[as+1].hi)) {
      b[bs].hi = a[as+1].hi
      as++
    } else {
      bs++
      b[bs].lo = a[as].lo
      b[bs].hi = a[as].hi
    }
    as++ }
  return bs<as ? _Merge(i,b,c) : copy(b,c) }
```

### class Num
Incrementally summarize numerics

```awk
func Num(i,pos,txt) {
  i.is ="Num"
  i.txt= txt
  i.pos= pos
  if (txt ~ /</) i.w = -1
  if (txt ~ />/) i.w =  1
  i.lo=  10^32
  i.hi= -10^32
  i.n= i.sd = i.mu = i.md = 0 }

#### Add
Incrementally add new data, update `mu`, `sd`, `n    

```awk
func _Add(i,x,   i)  { 
  if (x=="?") return x
  if(x>i.hi) i.hi=x
  if(x<i.lo) i.lo=x
  i.n++
  d     = x - i.mu
  i.mu += d / i.n
  i.m2 += d * (x - i.mu) 
  i.sd  = (i.n<2 ?0: (i.m2<0 ?0: (i.m2/(i.n - 1))^0.5)) }
```

#### Sub
Subtract new data, update `mu`, `sd`, `n`    

```awk
func _Sub(x,     d)
  if x == "?" return x
  i.n  -= 1
  d     = x - i.mu
  i.mu -= d / i.n
  i.m2 -= d * (x - i.mu) 
  i.sd  = (i.n<2 ?0: (i.m2<0 ?0: (i.m2/(i.n - 1))^0.5)) }
```

#### Norm
Return a number 0..1, min..max

```awk
func _Norm(i,x) { return (x - i.lo) / (i.hi - i.lo) }
```

#### CDF
Return area under the probability curve below `-&infin; &le x`.

```awk
func _CDF(i,x)      { 
  x=(x-i.mu)/i.sd; return 1/(1 + 2.71828^(-0.07056*x^3 - 1.5976*x)) }
```

#### AUC
Area under the curve between two points

```awk
func _AUC(i,x,y) {return (x>y)? _AUC(i,y,x): _CDF(i,y) - _CDF(i,x)}
```

### Class Sym

```awk
func Sym(i) { 
  i.is = "Sym"
  i.txt= txt
  i.pos= pos
  i.n  = i.most = 0
  i.mode =""
  has(i,"seen") }
```
  
#### Sub
Add new data, update `mu`, `sd`, `n`    

```awk
func _Add(i,x,  tmp) {
  if (x == "?") return v
  i.n++
  tmp = ++i.seen[x]
  if (tmp > i.most) { i.most = tmp; i.mode = x }}
```

#### Sub
Subtract new data, update `mu`, `sd`, `n`    
adn: 
```awk
func _Sub(i,x) {
  if (x == "?") return x
  if( --i.n       < 1) i.n=0
  if( --i.seen[x] < 1) delete i.seen[x] }
```
 awwk  
#### AUC
Area under the curve between two points

```awk
func _AUC(i,x) { return i.seen[x]/i.n }
```
