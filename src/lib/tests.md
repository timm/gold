<a name=top>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a>) ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a>) ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a>) ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a>) ::
[&copy;2020](http://github.com/timm/gold/blob/master/LICENSE.md#top) by <a href="http://menzies.us">Tim Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<img width=300 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

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
