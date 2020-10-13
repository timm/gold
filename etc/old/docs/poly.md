[home](https://github.com/timm/gold/blob/master/README.md) ::
[lib](https://github.com/timm/gold/blob/master/src/lib/README.md) ::
[cols](https://github.com/timm/gold/blob/master/src/cols/README.md) ::
[rows](https://github.com/timm/gold/blob/master/src/rows/README.md) ::
[&copy;2020](http://github.com/timm/gold/blob/master/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = a Gawk Object Layer
<img  width=300 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

[home](http://github.com/timm/gold/README.me) ::
[lib] ::
[cols] ::
[rows] ::
[&copy; 2020](http://github.com/timm/gold/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = the Gawk Object Layer
----- 

```awk
function add(i,x,       k,f) {k=i.ois; f=k "Add";  return @f(i,x)}
function loop(i,        k,f) {k=i.ois; f=k "Loop"; return @f(i)}
function like(i,x,y,z,  k,f) {k=i.ois; f=k "Like"; return @f(i,x,y,z)}
```
