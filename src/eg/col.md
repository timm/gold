<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies.us">Tim&nbsp;Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<img width=250 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">
<em>A <a href="https://en.wikipedia.org/wiki/Little_auk">little <strike>auk</strike> awk</a>  goes a long way.</em>

## Col
Incrementally summarize columns

<details open><summary>Contents</summary>

- [class Some](#class-some) : Reservoir sampling: just keep up to `i.max` items.
  - [Some](#some) : Initialize
  - [Some](#some) : Add a new item (if reservoir not full). Else, replace an old item.
- [class Num](#class-num) : Incrementally summarize numerics
  - [constructor Num](#constructor-num) : Create a new `Num`.
  - [method Add](#method-add) : Incrementally add new data, update `mu`, `sd`, `n`   
  - [method Norm](#method-norm) : Return a number 0..1, min..max
  - [method CDF](#method-cdf) : Return area under the probability curve below `-&infin; &le x`.
  - [method AUC](#method-auc) : Area under the curve between two points
- [class Sym](#class-sym) : Incrementally summarize numerics
  - [constructor Sym](#constructor-sym) : Create a new `Sym`.
  - [method Add](#method-add) : Add new data, update `mu`, `sd`, `n`    
  - [method AUC](#method-auc) : Area under the curve between two points

</details>

### class Some
Reservoir sampling: just keep up to `i.max` items.

<ul>

#### Some
Initialize

<ul><details><summary>...</summary>

```awk
function Some(i) { 
  i.is="Some"; i.sorted=0; 
  i.Size = 0.5
  i.Small = 4
  i.Epsilon = 0.01
  has(i,"all"); i.n=0; i.max=256 }
```
</details></ul>

#### Some
Add a new item (if reservoir not full). Else, replace an old item.

<ul><details><summary>...</summary>

```awk
@include "/../lib/list" # get "any"

function _Add((i,x) {
  if (x=="?") return x
  if (length(i.all) < i.max)     return i.all[1+length(i.all)]=x
  if (rand()        < i.max/i.n) return i.all[     any(i.all)]=x }

function _Sd(i,lo,hi,   p10,p90) {
  if(!sorted) i.sorted=asort(i.all)
  p10 = int(0.5 + (hi - lo)*.1)
  p90 = int(0.5 + (hi - lo)*.9)
  return (i.all[p90] - i.all[p10])/2.56 }

function _Better(i,a,b,c,     sd0,sd1,sd2,sd12,n1,n2) {
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

function _Merge(i,a,c,    amax,as,b,bs) {
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
</details></ul>
</ul>

### class Num
Incrementally summarize numerics

<ul>

#### constructor  Num
Create a new `Num`.

<ul><details><summary>...</summary>

```awk
function Num(i,pos,txt) {
  i.is ="Num"
  i.txt= txt
  i.pos= pos
  if (txt ~ /</) i.w = -1
  if (txt ~ />/) i.w =  1
  i.lo=  10^32
  i.hi= -10^32
  i.n= i.sd = i.mu = i.md = 0 }
```
</details></ul>

#### method Add
Incrementally add new data, update `mu`, `sd`, `n`   

<ul><details><summary>...</summary>

```awk
function _Add(i,x,   i)  { 
  if (x=="?") return x
  if(x>i.hi) i.hi=x
  if(x<i.lo) i.lo=x
  i.n++
  d     = x - i.mu
  i.mu += d / i.n
  i.m2 += d * (x - i.mu) 
  i.sd  = (i.n<2 ?0: (i.m2<0 ?0: (i.m2/(i.n - 1))^0.5)) }
```
</details></ul>

#### method Norm
Return a number 0..1, min..max

<ul><details><summary>...</summary>

```awk
function _Norm(i,x) { return (x - i.lo) / (i.hi - i.lo) }
```
</details></ul>

#### method CDF
Return area under the probability curve below `-&infin; &le x`.

<ul><details><summary>...</summary>

```awk
function _CDF(i,x)      { 
  x=(x-i.mu)/i.sd; return 1/(1 + 2.71828^(-0.07056*x^3 - 1.5976*x)) }
```
</details></ul>

#### method AUC
Area under the curve between two points

<ul><details><summary>...</summary>

```awk
function _AUC(i,x,y) {return (x>y)? _AUC(i,y,x): _CDF(i,y) - _CDF(i,x)}
```
</details></ul> </ul>

### class Sym
Incrementally summarize numerics

<ul>

#### constructor Sym
Create a new `Sym`.

<ul><details><summary>...</summary>

```awk
function Sym(i) { 
  i.is = "Sym"
  i.txt= txt
  i.pos= pos
  i.n  = i.most = 0
  i.mode =""
  has(i,"seen") }
```
</details></ul>
  
#### method Add
Add new data, update `mu`, `sd`, `n`    

<ul><details><summary>...</summary>

```awk
function _Add(i,x,  tmp) {
  if (x == "?") return v
  i.n++
  tmp = ++i.seen[x]
  if (tmp > i.most) { i.most = tmp; i.mode = x }}
```
</details></ul>

#### method AUC
Area under the curve between two points

<ul><details><summary>...</summary>

```awk
function _AUC(i,x) { return i.seen[x]/i.n }
```
</details></ul></ul>
