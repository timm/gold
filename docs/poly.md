```awk
function add(i,x,       k,f) {k=i.ois; f=k "Add";  return @f(i,x)}
function loop(i,        k,f) {k=i.ois; f=k "Loop"; return @f(i)}
function like(i,x,y,z,  k,f) {k=i.ois; f=k "Like"; return @f(i,x,y,z)}
```
