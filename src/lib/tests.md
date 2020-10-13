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
