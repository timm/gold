<a name=top>
<p align=center><a
href="https://github.com/timm/gold/blob/master/doc/01tour.md#top">tour</a> :: <a
href="https://github.com/timm/gold/doc/02doco.md#top">doco</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/03testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/04functions.md#top">functions</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/05classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/06methods.md#top">methods</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/07tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/08examples.md#top">egs</a> <br>
<img src="https://github.com/timm/gold/blob/master/etc/img/coins.png"></p>
<h1 align=center><a href="/README.md#top">GOLD: the GAWK object layer</a></h1>
<p align=center><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a><br>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a> 
<a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a></p>


```awk
function Abcd(i) {
  Object(i)
  i.is = "Abcd" 
  has(i,"known")
  has(i,"a")
  has(i,"b")
  has(i,"c")
  has(i,"d")
  i.yes = i.no = 0
}

function AbcdInc(i,want, got,   x) {
  if (++i.known[want] == 1) i.a[want]= i.yes + i.no 
  if (++i.known[got]  == 1) i.a[got] = i.yes + i.no 
  want == got ? i.yes++ : i.no++ 
  for (x in i.known) 
    if (want == x) 
      want == got ? i.d[x]++ : i.b[x]++
    else 
      got == x    ? i.c[x]++ : i.a[x]++
}

function AbcdReport(i,   
                    x,p,q,r,s,ds,pd,pf,
                    pn,prec,g,f,acc,a,b,c,d) {
  p = " %4.2f"
  q = " %4s"
  r = " %5s"
  s = " |"
  ds= "----"
  printf(r s r s r s r s r s q s q s q s q s q s q s " class\n",
        "num","a","b","c","d","acc","pre","pd","pf","f","g")
  printf(r s r s r s r s r s q s q s q s q s q s q s "-----\n",
         "----",ds,ds,ds,ds,ds,ds,ds,ds,ds,ds)
  for (x in i.known) {
    pd = pf = pn = prec = g = f = acc = 0
    a = i.a[x]
    b = i.b[x]
    c = i.c[x]
    d = i.d[x]
    if (b+d > 0     ) pd   = d     / (b+d) 
    if (a+c > 0     ) pf   = c     / (a+c) 
    if (a+c > 0     ) pn   = (b+d) / (a+c) 
    if (c+d > 0     ) prec = d     / (c+d) 
    if (1-pf+pd > 0 ) g=2*(1-pf) * pd / (1-pf+pd) 
    if (prec+pd > 0 ) f=2*prec*pd / (prec + pd)   
    if (i.yes + i.no > 0 ) 
       acc  = i.yes / (i.yes + i.no) 
    printf( r s        r s r s r s r s p s p s  p s p s p s p s  " %s\n",
          i.yes+i.no,a,  b,  c,  d,  acc,prec,pd, pf, f,  g,  x) }
}
```
