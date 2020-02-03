# vim: filetype=awk nospell ts=2 sw=2 sts=2 et :

function cat(a,u,  i,sep,s) {
  for(i in a) {
   s= s sep a[i]
   sep= u ? u : ", " }
  return s
}
function pcat(a,u) { print cat(a,u) }
