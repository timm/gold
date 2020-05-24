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


# `Table` = Tables of Data

```awk
@include "col"
@include "num"
@include "sym"
@include "row"

function Table(i, headers,rows,c,r) {
  Object(i)
  i.is = "Table"
  has(i, "cols")
  has(i, "rows")
  has(i, "headers")
  for(c in headers) TableInc(i, headers[c],c)
  for(r in rows)    TableInc(i, rows[r] )
}
```

Updates.

```awk
function TableInc(i,row,      c) {
  if ("cells" in row)
    TableAdd(i, row.cells)
  else {
    if (length(i.cols)) 
      TableIncRow(i,row)
    else
      for(c in row) 
        TableIncCol(i, row[c], c) }
}
function TableIncCol(i,txt,pos,   s,k) {
  ColSymbols(s)
  if (txt ~ s.skip) return
  k = txt ~ s.num ? "Num" : "Sym"
  hass(i.cols,,k, txt, pos)
  if (txt ~ s.klass) i.klass=pos
  i.headers[pos] = txt
}
function TableIncRow(i,row,  r,c) {
  r = has(i.rows,,"Row")
  for(c in i.cols.all)  
    TableIncCell(i,row, i.rows[r].cells, i.cols.all[c])
}
function TableInCell(i,row, cells, col)
  cells[col.pos] = add(col, row[col.pos]) 
}
```
