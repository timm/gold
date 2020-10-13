[home](https://github.com/timm/gold/blob/master/README.md) :: <img align=right width=350 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">
[lib](https://github.com/timm/gold/blob/master/src/lib/README.md) ::
[cols](https://github.com/timm/gold/blob/master/src/cols/README.md) ::
[rows](https://github.com/timm/gold/blob/master/src/rows/README.md) ::
[&copy;2020](http://github.com/timm/gold/blob/master/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = a Gawk Object Layer

# Files

```awk
function csv(a,file,     j,b4, ok,line,x,y) {
  file  = file ? file : "-"           
  ok = getline < file
  if (ok <0) { print "missing "files > "/dev/stderr"; exit 1 }
  if (ok==0) { close(file);return 0 }                                    
  line = b4 $0                         
  gsub(/([ \t]*|#.*$)/, "", line)      
  if (!line)       return csv(a,file, line)           
  if (line ~ /,$/) return csv(a,file, line)           
  split(line, a, ",")                  
  for(i in a) {
    x=a[i]
    y=a[i]+0
    a[i] = x==y ? x : y
  }
  return 1
}
```
