<a name=top><img align=right width=400 src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<h1 align=left><a href="/README.md#top">GOLD: the Gawk object layer</a></h1> 
<p align=left> <a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a> </p><p align=left> 
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a>
<a href="https://zenodo.org/badge/latestdoi/237838701"><img i
   src="https://zenodo.org/badge/237838701.svg" alt="DOI"></a>
</p><br clear=all>


```awk
@include "ok"
@include "str"
@include "num"

BEGIN {  tests("numok","_like") }

function _like(f,  m,n) {
  print(1)
  srand(1)
  Num(n)
  oo(n)
  m=100
  while(m--) inc(n,rand())
  ok(f, NumLike(n,0.1) < NumLike(n,0.5))
}
```

Walk up a list of random numbers, adding to a `Num`
counter. Then walk down, removing numbers. Check
that we get to the same mu and standard deviation
both ways.

```awk
function _num(f,     n,a,i,mu,sd) {
  print(2)
  srand()
  Num(n,"c","v")
  List(a)
  for(i=1;i<=100;i+= 1) 
    push(a,rand()^2) 
  for(i=1;i<=100;i+= 1) { 
    add(n,a[i])
    if((i%10)==0) { 
     sd[i]=n.sd
     mu[i]=n.mu }}
  for(i=100;i>=1; i-= 1) {
    if((i%10)==0) {
      ok(f, n.mu, mu[i])
      ok(f, n.sd, sd[i])  }
    sub(n,a[i]) }
}
```

Check that it we pull from some initial Gaussian distribution,
we can sample it to find the same means and standard deviation.

```awk
function _any(f,     max,n,a,i,mu,sd,n0,n1,x) {
  srand(1)
  Num(n0)
  Num(n1)
  List(a)
  max=300
  for(i=1;i<=max;i+= 1) {
    x=sqrt(-2*log(rand()))*cos(6.2831853*rand())
    Num1(n0,x)
    push(a, x) 
  }
  for(i=1;i<=max;i+= 1) Num1(n1, NumAny(n0))
  ok(f,n0.sd, n1.sd,0.05)
  ok(f, (n0.mu-n1.mu)< 0.05,1 )
}
```
