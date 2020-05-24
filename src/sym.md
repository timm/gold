<a name=top><p align=center><img src="https://github.com/timm/gold/blob/master/etc/img/coins.png"></p>
<h1 align=center><a href="/README.md#top">GOLD: the GAWK object layer</a></h1> 
<p align=center><a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a></p><p align=center><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a><br> <a
href="https://github.com/timm/gold/blob/master/doc/11classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/12methods.md#top">methods</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/13testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/doc/14doco.md#top">doco</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/15tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/16examples.md#top">egs</a></p><br clear=all>


# `Sym` = Symbolic Columns

```awk
@include "col"

function Sym(i,txt,pos) {
  Col(i,txt,pos)
  i.is ="Sym"
  has(i,"all")
  i.mode = i.ent=  ""
  i.most = i.nk = 0

}  
```

Reports on the numbers

```awk
function SymVar(i) { return SymEnt(i) }
function SymMid(i) { return i.mode }

function SymEnt(i,    k,p,n) {
  if (i.ent == "")
    i.ent = 0
    for (k in i.all) {
      n = i.all[k]
      if (n>0) {      
        p = n / i.n
        i.ent -= p*log(p)/log(2) }}
  return i.ent
}
```

Updating the numbers

```awk
function SymInc(i,v) {
  if (v=="?") return v
  i.ent=""
  i.n++
  i.all[v]++
  if (i.all[v] == 1) i.nk++
  if (i.all[v] > i.most) {
    i.most = i.all[v]
    i.mode = v }
  return v
}
function SymDec(i,v) {
  if (v=="?") return v
  if (v in i.all) 
    if (i.all[v] > 0)  {
      i.ent=""
      i.all[v]--
      i.n--
  }
  return v
}

```
