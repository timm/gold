<a name=top><img align=right width=400 src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<h1 align=left><a href="/README.md#top">GOLD: the GAWK object layer</a></h1> 
<p align=left> <a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a> </p><p align=left> 
<a href="https://doi.org/10.5281/zenodo.3841466"><img 
   src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a></p><br clear=all>


```awk
@include "ok"
@include "str"
@include "num"
@include "poly"
@include "list"

BEGIN {  tests("numok","_like,_num") }

function _like(f,  m,n) {
  srand(1)
  Num(n)
  m=100
  while(m--) inc(n,rand())
  ok(f 1, NumLike(n,0.1) < NumLike(n,0.5))
  ok(f 2, NumLike(n,0.9) < NumLike(n,0.5))
}
```

Walk up a list of random numbers, adding to a `Num`
counter. Then walk down, removing numbers. Check
that we get to the same mu and standard deviation
both ways.

```awk
function _num(f,     n,a,i,mu,sd) {
  srand()
  Num(n,"c","v")
  List(a)
  for(i=1;i<=100;i+= 1) 
    push(a,rand()^2) 
  for(i=1;i<=100;i+= 1) { 
    inc(n,a[i])
    if((i%10)==0) { 
     sd[i] = n.sd
     mu[i] = n.mu }}
  for(i=100;i>=1; i-= 1) {
    if((i%10)==0) {
      ok(f "_mu" i, near(n.mu, mu[i]))
      ok(f "_sd" i, near(n.sd, sd[i]))  }
    dec(n,a[i]) }
}
```