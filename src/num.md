<a name=top><p align=center><a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a><br>
<img src="https://github.com/timm/gold/blob/master/etc/img/coins.png"></p>
<h1 align=center><a href="/README.md#top">GOLD: the GAWK object layer</a></h1>
<p align=center><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a> <br> <a
href="https://github.com/timm/gold/blob/master/doc/01tour.md#top">tour</a> :: <a
href="https://github.com/timm/gold/doc/02doco.md#top">doco</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/03testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/04functions.md#top">functions</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/05classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/06methods.md#top">methods</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/07tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/08examples.md#top">egs</a></p>


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
```

Reports on the numbers

```awk
function NumVar(i) { return i.sd }
function NumMid(i) { return i.mu }

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
From a [Stackoverflow](https://stackoverflow.com/questions/52021422/finding-the-intersection-of-gaussian-distributions)
discussion:
```awk
function NumChop(i,j,     a,b,c,d,x1,x2) {
  if (i.mu > j.mu)              return NumChop(j,i)
  if ((j.mu - 0.3*j.sd) < i.mu) return
  if ((i.mu + 0.3*i.sd) > j.mu) return
  if (i.sd == 0)                return
  if (j.sd == 0)                return
  a  = 1/(2*i.sd^2) - 1/(2*j.sd^2)
  b  = j.mu/(j.sd^2) - i.mu/(i.sd^2)
  c  = i.mu^2/(2*i.sd^2) - j.mu^2/(2*j.sd^2) - math.log(j.sd/i.sd)
  d  = b^2 - 4 * a * c
  x1 = (-b + math.sqrt(d))/(2*a)
  x2 = (-b - math.sqrt(d))/(2*a)
  return (i.mu <= x1 && x1 <= j.mu) ? x1 : x2
} 
```

Updating the numbers

```awk
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
  if (i.n <= 1) {
    i.sd = 0
    return v 
  }
  i.n  -= 1
  d     = v - i.mu
  i.mu -= d/i.n
  i.m2 -= d*(v- i.mu)
  NumSd(i)
  return v
}
```
