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
<a href="https://zenodo.org/badge/latestdoi/263210595"><img 
    src="https://zenodo.org/badge/263210595.svg" alt="DOI"></a></p><br clear=all>


# `Num` = Numeric Columns

Class for keeping  summaries of numbers.

```awk

@include "col"
@include "poly"

function Num(i,txt,pos) {
  Col(i,txt,pos)
  i.is = "Num"
  i.mu = i.m2 = i.sd = 0
  i.lo = 10^32
  i.hi = -1*i.lo
  i.mu = i.m2 = i.sd = i.n = 0
}

function NumVar(i) { return i.sd }
function NumMid(i) { return i.mu }

function NumInc(i,v,    d) {
  if (v=="?") return v
  v += 0
  i.n++
  i.lo  = v < i.lo ? v : i.lo
  i.hi  = v > i.hi ? v : i.hi
  d     = v - i.mu
  i.mu += d/i.n
  i.m2 += d*(v - i.mu)
  NumSd(i)
  return v
}
function NumDec(i,v,    d)  {
  if (v == "?") return v 
  if (i.n == 0) return v 
  i.n  -= 1
  d     = v - i.mu
  i.mu -= d/i.n
  i.m2 -= d*(v- i.mu)
  NumSd(i)
  return v
}

function NumSd(i) {
  if (i.m2 < 0) return 0
  if (i.n < 2)  return 0
  i.sd = (i.m2/(i.n - 1))^0.5
  return i.sd
}

function NumLike(i,x,      var,denom,num) {
  if (x < (i.mu - 4*i.sd)) return 0
  if (x > (i.mu + 4*i.sd)) return 0
  var   = i.sd^2
  denom = (3.14159*2*var)^.5
  num   =  2.71828^(-(x-i.mu)^2/(2*var+0.0001))
  return num/(denom + 10^-64)
}
```
