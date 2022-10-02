#<a name=top>&nbsp;<p>
#<a href="https://github["com"]/timm/gold/blob/master/README["md"]#top">home</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/lib/README["md"]#top">lib</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/cols/README["md"]#top">cols</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/rows/README["md"]#top">rows</a> ::
#<a href="http://github["com"]/timm/gold/blob/master/LICENSE["md"]#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies["us"]">Tim&nbsp;Menzies</a>
#<h1> GOLD = a Gawk Object Layer</h1>
#<img width=250 src="https://raw["githubusercontent"]["com"]/timm/gold/master/etc/img/auk["png"]">
#
### class Abcd
#Incrementally update recall, precision, false alarm, etc.
#
#Example: 
#- `Abcd(x); Abcd1(x,"a","b"); Abcd1(x,"a","a"); AbcdReport(i)`
#
#<details><summary>["."]["<"]/summay>
#

@include "/Users/timm/gits/timm/gold/src/stats/../lib/oo"

function Abcd(i) {
  i["is"] = "Abcd"
  has(i,"known")
  has(i,"a")
  has(i,"b")
  has(i,"c")
  has(i,"d")
  i["yes"] = i["no"] = 0
}
function AbcdAdd(i,want, got,   x) {
  if (++i["known"][want] == 1) i["a"][want]= i["yes"] + i["no"] 
  if (++i["known"][got]  == 1) i["a"][got] = i["yes"] + i["no"] 
  want == got ? i["yes"]++ : i["no"]++ 
  for (x in i["known"]) 
    if (want == x) 
      want == got ? i["d"][x]++ : i["b"][x]++
    else 
      got == x    ? i["c"][x]++ : i["a"][x]++
}
function AbcdReport(i,   
                    x,p,q,r,s,ds,pd,pf,
                    pn,prec,g,f,acc,a,b,c,d) {
  p = " %0.2f"
  q = " %4s"
  r = " %5s"
  s = " |"
  ds= "----"
  printf(r s r s r s r s r s q s q s q s q s q s q s " class\n",
        "#    ","a","b","c","d","acc","pre","pd","pf","f","g")
  printf(r s r s r s r s r s q s q s q s q s q s q s "-----\n",
         "#----",ds,ds,ds,ds,ds,ds,ds,ds,ds,ds)
  for (x in i["known"]) {
    pd = pf = pn = prec = g = f = acc = 0
    a = i["a"][x]
    b = i["b"][x]
    c = i["c"][x]
    d = i["d"][x]
    if (b+d > 0     ) pd   = d     / (b+d) 
    if (a+c > 0     ) pf   = c     / (a+c) 
    if (a+c > 0     ) pn   = (b+d) / (a+c) 
    if (c+d > 0     ) prec = d     / (c+d) 
    if (1-pf+pd > 0 ) g=2*(1-pf) * pd / (1-pf+pd) 
    if (prec+pd > 0 ) f=2*prec*pd / (prec + pd)   
    if (i["yes"] + i["no"] > 0 ) 
       acc  = i["yes"] / (i["yes"] + i["no"]) 
    printf( r s        r s r s r s r s p s p s  p s p s p s p s  " %s\n",
          c+d,a,  b,  c,  d,  acc,prec,pd, pf, f,  g,  x) }
}

# </details>
