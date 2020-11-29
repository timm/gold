#  nb.gold

<small>


</small>



@include "lib"
@include "rows"

 function NB(i:nil) {
  i.K = 2
  i.M = 1
  has(i,"all")
  has(i,"some")

_Looping
If reading data, returns its klass
As a side-effect, ensure that there is a thing of this class

<ul><details><summary><tt>_Looping(i:NB, f:fnmae, record:nil)</tt></summary>

```awk
function _Looping(i:NB,f:fnmae,record:nil,    status,klassrecord) {
  if (csv(record,f)) {
    if (add(i.all,record)) {
      klass = record[i.all.klass]
      if (! (klass in i.some))  
        has(i.some,klass,"Rows",i.all.names) ;
      add(i.some[klass], a) }}
```

</details></ul>

_Classify

<ul><details><summary><tt>_Classify(i:NB, a:array)</tt></summary>

```awk
function _Classify(i:NB,,a:array,     x,l,most,out) {
  most = -1E-128
  for(x in i.some) {
    out = out ? out : x
    l = like(i.some[x],a,length(i.some[x].rows),length(i.some),i.M,i.K)
    if (l > most) {
        most = tmp
        out  = x }}
  return out }
```

</details></ul>

_Like

<ul><details><summary><tt>_Like(i:Row, a:array)</tt></summary>

```awk
function _Like(i:Row,a:array,y, n,hs,m,k,    prior,like,c,x) {
  prior = like = (length(i.rows) + k)/(n + k*hs)
  like  = log(like)
  for(c in a) 
    if(c in i.xs) {
      x = a[c]
      if(x != "?") 
        like += log( like(i.cols[c], x, prior, k, m)) }
  return like }
```

</details></ul>
