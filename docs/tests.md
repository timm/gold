#  tests.gold
- [vim: ft=awk ts=2 sw=2 et :](/docs/tests.md#vim-ftawk-ts2-sw2-et-) : @include "lib"
  - [csv1](/docs/tests.md#csv1)
  - [tab0](/docs/tests.md#tab0)
  - [tab1](/docs/tests.md#tab1)
  - [zs](/docs/tests.md#zs)
  - [dists1a](/docs/tests.md#dists1a)
  - [far1](/docs/tests.md#far1)
  - [oo1](/docs/tests.md#oo1)
  - [cluster1](/docs/tests.md#cluster1)
- [print "better" RowsY(cl.leaves[i])](/docs/tests.md#print-better-rowsyclleavesi) :  #          print "worse"  RowsY(cl.leaves[j])
  - [BEGIN{](/docs/tests.md#begin)


# vim: ft=awk ts=2 sw=2 et :
@include "lib"
@include "col"
@include "rows"
@include "cluster"
@include "contrast"

## csv1

<ul><details><summary><tt>csv1()</tt></summary>

```awk
function csv1(s,    f,d,a) {
  d = Gold.dot 
  f = d d "/data/" "weather" d "csv"
  while(csv(a, f)) o(a)
}
```

</details></ul>

## tab0

<ul><details><summary><tt>tab0()</tt></summary>

```awk
function tab0(s,rows,f,  d,t) {
  d = Gold.dot 
  Rows(t)
  RowsLoad(t,d d "/data/" f d "csv")
  ok(s,rows,length(t.rows))
}
```

</details></ul>

## tab1

<ul><details><summary><tt>tab1()</tt></summary>

```awk
function tab1(i,t) { print(10); tab0(i,14,  "weather")}
function tab2(i,t) { tab0(i,398, "auto93" )}
```

</details></ul>

## zs

<ul><details><summary><tt>zs()</tt></summary>

```awk
function zs(    n,a,i) {
   n=10^4
   while(--n > 0) a[n]=z(10,1)
   asort(a)
   for(i=0;i<=length(a);i = int(i+ length(a)/20))
      print(i,a[i])
}
function num1(s, n,a,i) {
  Num(n)
  split("11,21,10,42,53",a,/,/)
  for(i in a) add(n, asNum(a[i]))
  ok(s, 19.243, 19.244, 0.01) }
```

</details></ul>

## dists1a

<ul><details><summary><tt>dists1a()</tt></summary>

```awk
function dists1a(f,   d,t,r1,r2,n) {
  d = Gold.dot 
  Rows(t)
  RowsLoad(t,d d "/data/" f d "csv")
  n=50
  for(r1 in t.rows)
    for(r2 in t.rows) 
      if(r1>r2) { #&& r1==924046 && r2==332195) {
        if(--n <0) return 1
        print(r1,r2,RowDist(t.rows[r1], t.rows[r2], t, t.xs),
             o(t.rows[r1].cells),
             o(t.rows[r2].cells)) }}
```

</details></ul>

## far1

<ul><details><summary><tt>far1()</tt></summary>

```awk
function far1(f,   d,t,n,far,r1,r2) {
  d = Gold.dot 
  Rows(t)
  RowsLoad(t,d d "/data/" f d "csv")
  n=10
  for(r1 in t.rows) {
     if(--n < 0) break
     far = RowsFar(t,r1)
     print("far",far,"r1",r1,"d", RowsDist(t,r1,far),
             o(t.rows[r1].cells),
             o(t.rows[far].cells)) }}
```

</details></ul>

## oo1

<ul><details><summary><tt>oo1()</tt></summary>

```awk
function oo1(f,   a) {
  a[10][100]=10
  a[10][200]=20
  a[10][300]=30
  a[10][400][4] = 40 
  a[20][1][2]=20
  oo(a,"|") }
```

</details></ul>

## cluster1

<ul><details><summary><tt>cluster1()</tt></summary>

```awk
function cluster1(f,   r,d,rs,cl,i,j,k,out,dom) {
  d = Gold.dot 
  Rows(rs)
  RowsLoad(rs,d d "/data/" f d "csv")
  RowsBins(rs)
  Cluster(cl,rs)
  #oo(cl.leaves)
  for(i in cl.leaves)  {
     for(j in cl.leaves) 
       if(i != j) {
         if (dominates(cl.leaves[i],cl.leaves[j],rs))  
            {
            dom[i].name=i
            dom[i].dom++ }}}
  keysort(dom, "dom")
  for(i in dom) 
    print dom[i].name, dom[i].dom,RowsY(cl.leaves[dom[i].name]) }
```

</details></ul>

#           print "better" RowsY(cl.leaves[i])
 #          print "worse"  RowsY(cl.leaves[j])
  #         delete out
   #        bore(cl.leaves[i], cl.leaves[j],out)
    #       print("")
     #      for(k in out) print out[k].str
  #print(">>", i, length(cl.leaves[i].rows))
  #for(r in rs.rows) {
  #   print " "
  #   print r ","o(rs.rows[r].cells)
  #   print r ","o(rs.rows[r].bins)
  #}
  #oo(out)
  #ClusterPrint(cl)

## BEGIN{ 

<ul><details><summary><tt>BEGIN{ ()</tt></summary>

```awk
BEGIN{ 
  srand(1)
  #tests("csv1"); 
  #tests("tab2")
  #zs()
  #tests("num1")
  #dists1a("weather")
  #far1("auto93")
  #far1("auto93k25")
  #oo1("11")
  cluster1("auto93")
  rogues()
}
```

</details></ul>
