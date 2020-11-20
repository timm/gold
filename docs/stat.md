#  stat.gold
- [Incremental calculator for accuracy, precion, recall, etc](#incremental-calculator-for-accuracy-precion-recall-etc) : e.g.
  - [Abcd](#abcd)
  - [_Adds](#_adds)
  - [_Report](#_report)


------------------------------------------
Stats collection
 
Copyright (c) 2020, tim menzies.   
Licensed under the mit license 
For full license info, see license.md in the project root.

------------------------------------------

@include "lib"

------------------------------------------

# Incremental calculator for accuracy, precion, recall, etc
e.g.

    Abcd(x)
    n=500
    while(n--) {
     want=1
     got=rand()>0.5
     AbcdAdds(x,want,got) } #e.g

## Abcd

<ul><details><summary><tt>Abcd()</tt></summary>

```awk
function Abcd(i) {
  # Constructor
  has(i,"known")
  has(i,"a")
  has(i,"b")
  has(i,"c")
  has(i,"d")
  i.yes = i.no = 0 }
```

</details></ul>

## _Adds

<ul><details><summary><tt>_Adds()</tt></summary>

```awk
function _Adds(i,want, got,   x) {
  # Increment stats; e.g. if wnat==got then accuracy increases.
  if (++i.known[want] == 1) i.a[want]= i.yes + i.no 
  if (++i.known[got]  == 1) i.a[got] = i.yes + i.no 
  want == got ? i.yes++ : i.no++ 
  for (x in i.known) 
    if (want == x) want == got ? i.d[x]++ : i.b[x]++
    else           got  == x   ? i.c[x]++ : i.a[x]++ }
```

</details></ul>

## _Report

<ul><details><summary><tt>_Report(i:Abcd)</tt></summary>

```awk
function _Report(i:Abcd,   x,p,q,r,s,ds,pd,pf,pn,prec,g,f,acc,a,b,c,d) {
  # Print a table of the results. 
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
          i.yes+i.no,a,  b,  c,  d,  acc,prec,pd, pf, f,  g,  x) } }
```

</details></ul>
