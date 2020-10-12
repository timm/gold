```awk
BEGIN                { List(GOLD) ; DOT=sprintf("%c",46) }
function has(i,f,k)  { return has0(i, f?f:"List", k?k:1+length(i[k])) }
function has0(i,f,k) { i[k][0]; @f(i[k]); delete i[k][0]; return k }
function List(i)     { split("",i,"") }
function Object(i)   { List(i); i.id = ++GOLD.id }
```
