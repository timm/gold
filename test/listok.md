```awk
@include "ok"
@include "list"

BEGIN { tests("listof", "_any") }

function _any(f,      a,c,i,out) {
  srand(1)
  split("abbccccdddddddd",a,"")
  for(i=1;i<=1024;i++) 
    out[i] = any(a)
  for(i in out) 
    c[out[i]]++
  for(i in c)   
    print i,c[i]
}  
```
