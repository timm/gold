<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies.us">Tim&nbsp;Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<em>A <a href="https://en.wikipedia.org/wiki/Little_auk">little <strike>auk</strike> awk</a>  goes a long way.</em><br>
<img width=250 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

## Col
Incrementally summarize columns

<details open><summary>Contents</summary>

- [class Some](#class-some) : Reservoir sampling: just keep up to `i.max` items.
  - [constructor Some](#constructor-some) : Initialize
  - [method Add](#method-add) : Add a new item (if reservoir not full). Else, replace an old item.
  - [method Sd](#method-sd) : Compute the standard deviation of a list of sorted numbers.
  - [method Better](#method-better) : Returns true if it useful dividing the list `a` to `c` at the point  `b`.  
  - [method Div](#method-div) : Divide our list `i.all` into `a`; i.e. bins of size `sqrt(n)`. 
  - [method Merge](#method-merge) : Combine adjacent pairs of bins (if they too similar). Loop until there are no more combinable  bins.
- [class Num](#class-num) : Incrementally summarize numerics.
  - [constructor Num](#constructor-num) : Create a new `Num`.
  - [method Add](#method-add) : Incrementally add new data, update `mu`, `sd`, `n`   
  - [method Norm](#method-norm) : Return a number 0..1, min..max
  - [method CDF](#method-cdf) : Return area under the probability curve below `-&infin; &le x`.
  - [method AUC](#method-auc) : Area under the curve between two points
- [class Sym](#class-sym) : Incrementally summarize numerics
  - [constructor Sym](#constructor-sym) : Create a new `Sym`.
  - [method Add](#method-add) : Add new data, update `mu`, `sd`, `n`    
  - [method Merge](#method-merge) : Returns true if  combing two `Sym`s does not have larger entropy that the parts.
  - [method Ent](#method-ent) : Compute the entropy of the stored symbol counts.
  - [method AUC](#method-auc) : Area under the curve between two points

</details>


### class Some
Reservoir sampling: just keep up to `i.max` items.

<ul>

#### constructor Some
Initialize

<ul><details><summary>...</summary>

```awk
function Some(i, post,txt) { 
  i.is="Some"; i.sorted=0; 
  i.Size = 0.5
  i.Small = 4
  i.Epsilon = 0.01
  i.pos = pos
  i.txt = txt
  has(i,"all"); i.n=0; i.max=256 }
```
</details></ul>

#### method Add
Add a new item (if reservoir not full). Else, replace an old item.

<ul><details><summary>...</summary>

```awk
@include "/../lib/list" # get "any"

function _Add((i,x) {
  if (x=="?") return x
  if (length(i.all) < i.max)     return i.all[1+length(i.all)]=x
  if (rand()        < i.max/i.n) return i.all[     any(i.all)]=x }
```
</details></ul>


#### method Sd
Compute the standard deviation of a list of sorted numbers.

Uses the trick that the standard deviation can be approximated using the 90th-10th percentile (divided by 2.56).

<ul><details><summary>...</summary>

```awk
function _Sd(i,lo,hi,   p10,p90) {
  if(!sorted) i.sorted=asort(i.all)
  p10 = int(0.5 + (hi - lo)*.1)
  p90 = int(0.5 + (hi - lo)*.9)
  return (i.all[p90] - i.all[p10])/2.56 }
```
</details></ul>


#### method Better
Returns true if it useful dividing the list `a` to `c` at the point  `b`.  

<ul><details><summary>...</summary>

```awk
function _Better(i,a,b,c,     sd0,sd1,sd2,sd12,n1,n2) {
  n1   = b-a
  n2   = c-b-1
  sd0  = _Sd(i,a,c)
  sd1  = _Sd(i,a,b)
  sd2  = _Sd(i,b+1,c)
  sd12 = n1/(n1+n2) * sd1 + n2/(n1+n2) * sd2
  return sd0 - sd12 > i.Epsilon }
```
</details></ul>


#### method Div
Divide our list `i.all` into `a`; i.e. bins of size `sqrt(n)`. 

<ul><details><summary>...</summary>

```awk

function _Div(i,a,    n0,n1,lo,hi,bins,b) {
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
    a[as].hi = alls }}
```
</details></ul>

#### method Merge
Combine adjacent pairs of bins (if they too similar). Loop until there are no more combinable  bins.

<ul><details><summary>...</summary>

```awk
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
Incrementally summarize a stream of numerics.

e.g.

    Num(x)
    for(i=1; i<= 500; i++) @Add(x, rand()**2 )
    print(x.mu, x.sd)

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
Incrementally summarize a stream of symbols.

<ul>

#### constructor Sym
Create a new `Sym`.

<ul><details><summary>...</summary>

```awk
function Sym(i, pos,txt) { 
  i.is = "Sym"
  i.Epsilon = 0.01
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

#### method Merge
Returns true if  combing two `Sym`s does not have larger entropy that the parts.

As a side-effect, compute that combined item.

<ul><details><summary>...</summary>

```awk
function _Merge(i,j,k) {
  Num(k,i.pos,i.txt)
  k.n = i.n + j.n
  for(x in i.seen) k.seen[x] += i.seen[x]
  for(x in j.seen) k.seen[x] += j.seen[x]
  for(x in k.seen) 
    if (k.seen[x] > k.most) { k.most = k.seen[x]; k.mode=x }
  e1  = _Ent(i);  n1  = i.n
  e2  = _Ent(j);  n2  = j.n
  e12 = _Ent(k);  n12 = k.n
  return e12 - (n1/n12 * e1 + n2/n12*e2) <= i.Epsilon }
```
</details></ul>

#### method Ent
Compute the entropy of the stored symbol counts.

<ul><details><summary>...</summary>

```awk
function _Ent(i, e, p) {
  for(x in i.seen[x])
    if (i.seen[x]>0) {
      p  = i.seen[x]/i.n
      e -= p*log(p)/log(2) }
  return e }
```
</details></ul>



#### method AUC
Area under the curve between two points

<ul><details><summary>...</summary>

```awk
function _AUC(i,x) { return i.seen[x]/i.n }
```
</details></ul></ul>
