# vim: filetype=awk nospell ts=2 sw=2 sts=2 et :

function argv(b4,   x,k,old,new) {
  for (x in ARGV)  {
   k = ARGV[x]
   if (sub(/^--/,"",k))
     b4[k] = argv1(k, k in b4, b4[k], ARGV[x+1]) }
}
function argv1(k,known,old,new) {
  if (known) {
    if (typeof(old) != "number")
      return new
    else if (new ~ /[0-9]+(\.[0-9]*)?/)
      return strtonum(new)   }
  print "#W> bad arg --"k" " new
  exit 1
}
