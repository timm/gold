```awk
function add(i,row, k,f) { 
  k=i.ois; f=k "Add"; return @f(i,row) 
}

function it(i,      k,f) { 
  k=i.ois; f=k "It";  return @f(i)     
}
```
