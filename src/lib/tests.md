[home](https://github.com/timm/gold/blob/master/README.md) ::
[lib](https://github.com/timm/gold/blob/master/src/lib/README.md) ::
[cols](https://github.com/timm/gold/blob/master/src/cols/README.md) ::
[rows](https://github.com/timm/gold/blob/master/src/rows/README.md) ::
[&copy;2020](http://github.com/timm/gold/blob/master/LICENSE.md) by [Tim Menzies](http://menzies.us)   
<img align=right width=350 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">
# GOLD = a Gawk Object Layer

```awk
function red(x)   { return "\033[31m"x"\033[0m" }
function green(x) { return "\033[32m"x"\033[0m" }

function ok(s,y) {
  print( y? green("PASSED "s) : red("FAILED "s)) >"/dev/stderr"
}

function rogues(    s) {
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/)  print "#W> Rogue: " s>"/dev/stderr"
}
```
