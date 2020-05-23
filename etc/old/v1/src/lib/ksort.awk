# vim: filetype=awk nospell ts=2 sw=2 sts=2 et :

function ksort(lst,k) { 
  KSORT=k; return asort(lst,lst,"kSortCompare")
}
function kSortCompare(i1,v1,i2,v2,  l,r) {
  l = v1[KSORT] +0
  r = v2[KSORT] +0
  if (l < r) return -1
  if (l == r) return 0
  return 1 
} 
