BEGIN {
  split("a,b,v",a,",")
  for(i in a) print a[i]
}
