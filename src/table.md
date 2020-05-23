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
<a href="https://zenodo.org/badge/latestdoi/3841466"><img i
   src="https://zenodo.org/badge/3841466.svg" alt="DOI"></a>
</p><br clear=all>


# `Table` = Tables of Data

```awk
@include "col"
@include "num"
@include "sym"
@include "row"

function Table(i,headers) {
  Object(i)
  i.is = "Table"
  has(i,"cols")
  has(i,"rows")
  for(j in headers)
    TableCol(i,headers[j],j)
}

function TableCol(i,txt,pos,   s,k) {
  ColSymbols(s)
  k = txt ~ s.num ? "Num" : "Sym"
  hasss(i.cols,,k, txt, pos)
}

function TableClone(i,j,rows,   c,tmp) {
  for(c in i.cols) 
    tmp[c] = i.cols[c].txt
  Table(j, tmp)  
  for(r in rows)
    TableAdd(j,rows[r])
}

function TableAdd(i,row,      r,c) {
  if ("cells" in row)
    TableAdd(i, row.cells)
  else {
    r = has(i.rows,,"Row")
    for(c in i.cols.all) 
      i.rows[r].cells[c] = add(i.cols.all[c], row[c]) }
}
```
