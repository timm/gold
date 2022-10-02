#<a name=top>&nbsp;<p>
#<a href="https://github["com"]/timm/gold/blob/master/README["md"]#top">home</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/lib/README["md"]#top">lib</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/cols/README["md"]#top">cols</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/rows/README["md"]#top">rows</a> ::
#<a href="http://github["com"]/timm/gold/blob/master/LICENSE["md"]#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies["us"]">Tim&nbsp;Menzies</a>
#<h1> GOLD = a Gawk Object Layer</h1>
#<img width=250 src="https://raw["githubusercontent"]["com"]/timm/gold/master/etc/img/auk["png"]">
#
### Naive Bayes
#Basic Naive Bayes
#

@include "/Users/timm/gits/timm/gold/src/eg/../lib/oo"
@include "/Users/timm/gits/timm/gold/src/eg/../lib/files"
@include "/Users/timm/gits/timm/gold/src/eg/../stats/abcd"
@include "/Users/timm/gits/timm/gold/src/eg/../lib/tests"

BEGIN{ THE["seed"]=1 }

#----------------------------------------------------------
function Num(i,pos,txt) {
  i["is"]="Num"
  i["txt"]= txt
  i["pos"]= pos
  if (txt ~ /</) i["w"] = -1
  if (txt ~ />/) i["w"] =  1
  i["lo"]=  10^32
  i["hi"]= -10^32 }

function NumAdd(i,x)  { if(x<i["lo"]) i["lo"]=x; if(x>i["hi"]) i["hi"]=x }
function NumNorm(i,x) { return (x - i["lo"]) / (i["hi"] - i["lo"]) }

#----------------------------------------------------------
function Tab(i,f) { 
  i["is"]="Tab"; i["n"]=0; i["file"]=f; 
  has(i,"goals"); has(i,"row") }

function TabAdd(i, a) {
  i["n"]++
  for(c in a) 
    i["row"][n][c] = a[c]
  if(c in i["goals"]) 
    NumAdd(i["goals"][c], a[c]) }

function TabD(i,r1,r2,      c["x"],y,d,n) {
  for(c in i["goals"]) {
    n++
    x  = i["row"][r1][c]
    y  = i["row"][r2][c]
    x  = NumNorm(i["goals"][c], x)
    y  = NumNorm(i["goals"][c], y)
    d += (x-y)^2 }
  return (d/n)^0.5  }

function TabFar(i,r1, rows) {
  for(r2  in rows)
    if((d = TabD(i,r1,r2)) > most) { most = d; out = r2 }
  return out }

function TabHead(i, a) {
  for(c in a)
    if (a[c] ~ /<>/) 
      hAS(i["goals"], c, "Num", c, a[c]) }

function TabRead(i, a) {
  csv(i["file"],i["head"])
  TabHead(i["head"])
  while(csv(i["file"], a))
    add(i, a) }

#----------------------------------------------------------
function Tree(i) { has(i,"nodes"); i["Stop"]=0.5; i["Sample"] = 256 }

function TreeDiv(i,tab,rows) {
  if (length(rows))
    return TreeDiv1(i,tab,rows)
  n = n / length(all)
  for(r in tab["rows"])
    if(rand()< n)
      rows[r]=r 
  return TreeDiv(i, tab, rows,  length(rows)^i["Stop"]) }

function  TreeDiv1(i, tab, rows, stop,     k) {
  if(length(rows) >= 2*stop) { 
    k = moRE(i["nodes"], "TreeNode", rows, tab)
    if (i["nodes"][k]["good"]) {
      TreeDiv1(i, tab, i["nodes"][k]["lefts"],  stop)
      TreeDiv1(i, tab, i["nodes"][k]["rights"], stop) }}}
   
#----------------------------------------------------------
function TreeNode(i,rows,tab,     x,r,a,b,d,x,mid) {
  z       = any(rows) 
  i["left"]  = TabFar(tab, z,      rows)
  i["right"] = TabFar(tab, i["left"], rows) 
  i["c"]     = TabD(  tab, i["left"], i["right"])
  for(r in rows) {
    a = TabD(tab, r, i["left"])
    b = TabD(tab, r, i["right"]) 
    x = (a^2 + c^2 - b^2) / (2*c) 
    mid += d[r] = (x>1) ? x : ((x<0) ? 0 : x)
  }
  for(r in rows) {
    if(d[r] < mid/length(rows)) { n1++; i["lefts"][r]  }
    else                        { n2++; i["rights"][r] }}
   i["good"] = n1< length(rows) && n2 < length(rows) }
}

#----------------------------------------------------------
function any(a, i)      { i=int(0.5*length(a)); return (i<1)?1:i }
function add(i,x,  f)   { f=i["is"]"Add"; return @f(i,x)            }
function ksrt(a,k)      { THE["key"]=k  ; return asort(a,a,"ksrt1") }
function ksrt1(i,x,j,y) { return cmp(x[THE["key"]]+0, y[THE["key"]]+0) } 
function cmp(x,y)       { return (x < y) ? -1 : ((x==y) ? 0 : 1) }

function shuffle(a,  i,j,n,tmp) {
  n=length(a)
  for(i=1;i<=n;i++) {
    j=i+round(rand()*(n-i));
    tmp=a[j];
    a[j]=a[i];
    a[i]=tmp 
  }
  return n }


