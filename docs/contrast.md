#  contrast.gold
- [vim: ft=awk ts=2 sw=2 et :](/docs/contrast.md#vim-ftawk-ts2-sw2-et-)
  - [bore](/docs/contrast.md#bore)
  - [dominates](/docs/contrast.md#dominates)


# vim: ft=awk ts=2 sw=2 et :

@include "lib"
@include "col"
@include "rows"

## bore

<ul><details><summary><tt>bore(i:Rows, j:Rows, out:nil)</tt></summary>

```awk
function bore(i:Rows,j:Rows,out:nil,      I,J,c,v,b,r,n,s) {
  I = length(i.rows)
  J = length(j.rows)
  List(out)
  for(c in i.xs)
    for(v in i.cols[c].seen) {
      b = i.cols[c].seen[v]
      r = (v in j.cols[c].seen) ? j.cols[c].seen[v] : 0
      b = b/I
      r = r/J
      s = b^2/(b + r + 1E-32) 
      if (b > r) {
        n++
        out[n].str = c" = "v" : "int(100*s)
        out[n].col = c
        out[n].val = v
        out[n].y   = s }}
  keysort(out,"y") }
```

</details></ul>

## dominates

<ul><details><summary><tt>dominates(i:Rows, j:Rows, k:Rows)</tt></summary>

```awk
function dominates(i:Rows,j:Rows,k:Rows,      w,n,c,a,b,s1,s2) {
  n = length(i.ys)
  for(c in i.ys) {
    w   = k.cols[c].w
    a   = i.cols[c].mu
    b   = j.cols[c].mu
    a   = NumNorm(k.cols[c], a)
    b   = NumNorm(k.cols[c], b)
    s1 -= Gold.e^(w*(a-b)/n)
    s2 -= Gold.e^(w*(b-a)/n)
  }
  return s1/n <= s2/n }
```

</details></ul>
