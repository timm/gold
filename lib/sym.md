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


# `Sym` = Symbolic Columns

```awk
@include "col"

function Sym(i,txt,pos) {
  Col(i,txt,pos)
  i.is ="Sym"
  has(i,"all")
  i.mode = i.ent=  ""
  i.most = 0
}  

function SymVar(i) { return SymEnt(i) }
function SymMid(i) { return i.mode }

function SymInc(i,v) {
  if (v=="?"p) return v
  i.ent=""
  i.n++
  i.all[v]++
  if (i.all[v] > i.most) {
    i.most = i.all[v]
    i.mode = v }
  return v
}

function SymDec(i,v) {
  if (v=="?"p) return v
  i.ent=""
  i.n++
  i.all[v]++
  if (i.all[v] > i.most) {
    i.most = i.all[v]
    i.mode = v }
  return v
}

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