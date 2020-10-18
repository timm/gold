```awk
@include "/nb0"
@include "/../lib/tests"

func aa(i) { 
  Nb(i); NbRead(i); rogues(); 
  AbcdReport(i.log) 
  #oo(i.seen)
  }
BEGIN { aa() }
```
