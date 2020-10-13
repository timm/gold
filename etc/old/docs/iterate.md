[home](http://github.com/timm/gold/README.md) :: <img align=right width=200 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/robot.png">
[lib](https://github.com/timm/gold/blob/master/src/lib/index.md) ::
[cols] ::
[rows] ::
[&copy; 2020](http://github.com/timm/gold/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = the Gawk Object Layer

[home](http://github.com/timm/gold/README.me) ::
[lib] ::
[cols] ::
[rows] ::
[&copy; 2020](http://github.com/timm/gold/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = the Gawk Object Layer
----- 

# Iterate

```awk   
function csv(a,file,     b4, status,line,i,x) {
  file   = file ? file : "-"      # defaults to stdin
  status = getline < file
  if (status<0) {   
    print "#E> Missing f["file"]" # warn on missing file
    exit 1 
  }
  if (status==0) {
    close(file); 
    return 0
  }                               # close stream on exit
  line = b4 $0                    # accumulate over eol ","
  gsub(/([ \t]*|#.*$)/, "", line) # kill comments, blanks
  if (!line)       
    return csv(a,file, line)      # skip blank lines
  if (line ~ /,$/)
    return csv(a,file, line)      # accumulate over eol ","
  split(line, a, ",")             # split cells on ","
  for(i in a) {
    x= a[i]
    a[i] = x+0==x ? x+0 : x       # coerce to nums or strings
  }
  return 1
}
```

```awk
function Use(i,f) {
  Object(i)
  is(i,"Use")
  i.file = f
  has(i,"has")
  has(i,"what2do")
}
function UseLoop(i,    a,c,n) {
  if (!csv(a,i.file)) 
    return 0
  if (!length(i.what2do)) 
    for(c in a) 
      if (a[c] !~ /\?/)
        i.what2do[c] = ++n;
  for(c in i.what2do)  
    i.has[ i.what2do[c] ] = a[c]
  return 1
}
```
