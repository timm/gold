function nN(   i,j) {
  for(i=1;i<=10^6;i++) j+= i
  return i
}
BEGIN {
  for(i=1;i<=10;i++) {
      f= "n" "N"
      @f()
  }
}
