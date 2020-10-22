<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies.us">Tim&nbsp;Menzies</a>
<img width=250 align=right src="http://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">
<h1> GOLD = a Gawk Object Layer</h1>
<em>A <a href="https://en.wikipedia.org/wiki/Little_auk">little <strike>auk</strike> awk</a>  goes a long way.</em><br>

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
