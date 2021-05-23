
# skip.gold

@include "col"

```awk
function Skip(i,at,txt) {
  Col(i,at,txt)
  is(i, "Skip") }
function _Add(i,x) { return x }
```
