```awk
function add(i,row, k,f) { 
  k=i.ois; f=k "Add"; return @f(i,row) 
}

function loop(i,      k,f) { 
  k=i.ois; f=k "Loop";  return @f(i)     
}
```
