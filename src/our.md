# Our  shared constants

These get stored as nested lists within `AU`.

```awk
@include "str"

function TheChars(i) {
  i.skip ="\\?"
  i.less = "<"
  i.more = ">"
  i.klass= "!"
  i.num  = "\\$"
  i.sym  = ":"
  i.nums = "[" i.less i.more i.num "]" 
  i.goal = "[" i.less i.more i.klass "]" 
}
function TheTree(i) {
  i.nums= 10
}

BEGIN{
  has(AU,"ch",  "TheChars")
  has(AU,"tree","TheTree")
}
```
