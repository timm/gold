#  col.gold

<small>

  - [Abstract class: parent of all column](#abstract-class-parent-of-all-column)
    - [Col](#col) : Abstract constructor for our column.
    - [add](#add) : Polymorphic update function for columns.
    - [adds](#adds) : Add many things
    - [dist](#dist) : Distance between things.
    - [like](#like) : Return likelihood `x` belongs to `c`
  - [Columns to be ignored.](#columns-to-be-ignored)
    - [Info](#info) : Constructor for columns we will not summarize. 
    - [_Add](#add) : Do nothing.
  - [Summaries of columns of symbols](#summaries-of-columns-of-symbols)
    - [Sym](#sym) : Constructor for summary of symbolic columns.
    - [_Add](#add) : Update frequency counts, and `mode`.
    - [_Dist](#dist) : Distance calcs for `Sym`bols.
    - [_Like](#like)
  - [Summaries of columns of numbers](#summaries-of-columns-of-numbers)
    - [Num](#num) : Constructor of summary of numeric columms
    - [_Add](#add) : Update self, return `x`.
    - [_Pdf](#pdf) : Return height of the Gaussian at `x`.
    - [_Cdf](#cdf) : Return the area under the Gaussian from negative infinity to `x`.
    - [_Crossover](#crossover) : Return where two Gaussians cross in-between their means.
    - [_Norm](#norm) : Distance calcs for `Num`bols.
    - [_Dist](#dist) : Return normalized distance 0..1 between two numbers `x` and `y`.
    - [_Like](#like)

</small>



-----------------------------------------------
Tools for summarizing columns of data.
 
Copyright (c) 2020, Tim Menzies.  Licensed under the MIT license.
For full license info, see LICENSE.md in the project root

-----------------------------------------------

@include "lib"

## Abstract class: parent of all column

### Col
Abstract constructor for our column.
`s` is the name of a column appearing in positive `n`.

<ul><details><summary><tt>Col(i:untyped, s:string, n:posint)</tt></summary>

```awk
function Col(i:untyped, s:string, n:posint) { 
  Object(i); i.is="Col"
  i.txt=s; i.pos=n }
```

</details></ul>

### add
Polymorphic update function for columns.

<ul><details><summary><tt>add(i:Col, x:string)</tt></summary>

```awk
function add(i:Col,x:string,  f)  {
  f=i.is "Add"; 
  return @f(i,x) }
```

</details></ul>

### adds
Add many things

<ul><details><summary><tt>adds(c:Col, a:array)</tt></summary>

```awk
function adds(c:Col, a:array,   i) {
  for(i in a) add(c,a[i])}
```

</details></ul>

### dist
Distance between things.

<ul><details><summary><tt>dist(c:Col)</tt></summary>

```awk
function dist(c:Col, x,y,  f) {
  f=c.is "Dist"; return @f(c,x,y) }
```

</details></ul>

### like
Return likelihood `x` belongs to `c`

<ul><details><summary><tt>like(c:Col)</tt></summary>

```awk
function like(c:Col, x,prior,m,k,  f) {
  f=c.is "Like"; return @f(c,x,prior,m,k) }
```

</details></ul>

-----------------------------------------------

## Columns to be ignored. 

### Info
Constructor for columns we will not summarize. 

<ul><details><summary><tt>Info(i:untyped, s:string, n:posint)</tt></summary>

```awk
function Info(i:untyped, s:string, n:posint)  { 
  Col(i,s,n); i.is="Info" }
```

</details></ul>

### _Add
Do nothing.

<ul><details><summary><tt>_Add(i:Info, x:any)</tt></summary>

```awk
function _Add(i:Info, x:any) {
  return x}
```

</details></ul>

-----------------------------------------------

## Summaries of columns of symbols

### Sym
Constructor for summary of symbolic columns.
`s` is the name of a column appearing in positive `n`.

<ul><details><summary><tt>Sym(i:untyped, s:string, n:posint)</tt></summary>

```awk
function Sym(i:untyped, s:string, n:posint) { 
  Col(i,s,n); i.is="Sym"
  i.Trivial = 1.025
  has(i, "seen")
  i.mode= i.most= "" }
```

</details></ul>

### _Add
Update frequency counts, and `mode`.

<ul><details><summary><tt>_Add(i:Sym, x:atom)</tt></summary>

```awk
function _Add(i:Sym, x:atom,    n) {
  if(x=="?") return x
  i.n++
  n= ++i.seen[x]
  if (n> i.most) { i.mode=x; i.most=n}
  return x }  
```

</details></ul>

### _Dist
Distance calcs for `Sym`bols.

<ul><details><summary><tt>_Dist(i:Sym, x:atom, y:atom)</tt></summary>

```awk
function _Dist(i:Sym, x:atom, y:atom) {
  return x == y ? 0 : 1 }
```

</details></ul>

function _Var(i:Sym,      n,p,e) {
  ## Distance calcs for `Sym`bols.
  for(x in i.seen) 
    if((n = i.seen[x]) > 0)
      e -= (n/i.n)*log(n/i.n)/log(2)
  return e

function _Better(i:Sym,j:Sym,k:untypes, x,n,ei,ej,ek) {
  ## Return true if the union of `i,j` has less entropy than i.
  ## As a side effect, compute `k` (the union of the `i,j`).
  delete k
  copy(i,k)
  k.n = i.n + j.n
  for(x in j.seen) {
    n = k.seen[x] = k.seen[x] + j.seen[x]
    if (n> k.most) { k.mode=x; k.most=n } 
  }
  ei = _Var(i) * i.n/k.n
  ej = _Var(j) * j.n/k.n
  ek = _Var(k)
  return  (ei + ej)*i.Trivial > ek }
  

### _Like

<ul><details><summary><tt>_Like(i:Sym, x:any, prior:float, m:num, k:ignore)</tt></summary>

```awk
function _Like(i:Sym,x:any,prior:float,m:num,k:ignore,   f) {
   f = x in i.seen ? i.seen[x] : 0
   return (f+ i.M*prior) / (i.n + i.M) }
```

</details></ul>

-----------------------------------------------

##  Summaries of columns of numbers

### Num
Constructor of summary of numeric columms

<ul><details><summary><tt>Num(i:untyped, s:string, n:posint)</tt></summary>

```awk
function Num(i:untyped, s:string, n:posint) { 
  Col(i,s,n); i.is="Num"
  i.w  = (s ~ /</) ? -1 : 1 
  i.hi = -1E32
  i.lo =  1E32
  i.mu = i.m2= i.n= i.sd=0 }
```

</details></ul>

### _Add
Update self, return `x`.

<ul><details><summary><tt>_Add(i:Num, x:number)</tt></summary>

```awk
function _Add(i:Num, x:number,    d) {
  if(x=="?") return x
  i.n++
  if(x > i.hi) i.hi = x
  if(x < i.lo) i.lo = x
  d     = x - i.mu
  i.mu += d / i.n
  i.m2 += d * (x - i.mu) 
  i.sd  = (i.n<2 || i.m2<0) ? 0 : i.sd = (i.m2/(i.n-1))^0.5
  return x }
```

</details></ul>

### _Pdf
Return height of the Gaussian at `x`.

<ul><details><summary><tt>_Pdf(i:Num, x:any)</tt></summary>

```awk
function _Pdf(i:Num, x:any,    var,denom,num) {
  var   = i.sd^2
  denom = (2*Gold.pi*2*var)^.5
  num   = 2*Gold.e^(-(x-i.mu)^2/(2*var+0.0001))
  return num/(denom + 10^-64) }
```

</details></ul>

### _Cdf
Return the area under the Gaussian from negative infinity to `x`.

<ul><details><summary><tt>_Cdf(i:Num, x:number)</tt></summary>

```awk
function _Cdf(i:Num, x:number) { 
  x = (x-i.mu)/i.sd
  return (x<-3 || x>3) ? 0 : 1/(1+Gold.e^(-0.07056*x^3 - 1.5976*x))}
```

</details></ul>

### _Crossover
Return where two Gaussians cross in-between their means.

<ul><details><summary><tt>_Crossover(i:Num, j:Num)</tt></summary>

```awk
function _Crossover(i:Num,j:Num,   x1,x2,d,min,x,y,out) {
   x1  = i.mu
   x2  = j.mu
   if (x2 < x1) { x2=i.mu; x1=j.mu }
   d   = (x2-x1)/10
   min = 1E32
   for(x=x1; x<=x2; x+=d) {
      y = _Pdf(i) + _Pdf(j)
      if (y<min) { out=x; min = x }} 
   return out }
```

</details></ul>

### _Norm
Distance calcs for `Num`bols.

<ul><details><summary><tt>_Norm(i:Num, x:number)</tt></summary>

```awk
function _Norm(i:Num, x:number) {
  return  (x - i.lo) / (i.hi - i.lo ) } # 1E-30) }
```

</details></ul>

### _Dist
Return normalized distance 0..1 between two numbers `x` and `y`.

<ul><details><summary><tt>_Dist(i:Num, x:atom, y:atom|20)</tt></summary>

```awk
function _Dist(i:Num, x:atom, y:atom|20) {
  if      (x=="?") { y= _Norm(i,y); x=y>0.5? 0:1}
  else if (y=="?") { x= _Norm(i,x); y=x>0.5? 0:1}
  else             { x= _Norm(i,x)
                     y= _Norm(i,y) }
  return abs(x- y) }
```

</details></ul>

### _Like

<ul><details><summary><tt>_Like(i:Num, x:any, prior:ignore, m:ignore, k:ignore)</tt></summary>

```awk
function _Like(i:Num, x:any, prior:ignore, m:ignore,k:ignore var,denom,num) {
  var   = i.sd^2
  denom = (Gold.pi*2*var)^.5
  num   =  Gold.e^(-(x-i.mu)^2/(2*var+0.0001))
  return num/(denom + 1E-64) }
```

</details></ul>
