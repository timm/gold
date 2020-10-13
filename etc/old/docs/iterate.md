<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy; 2020</a> by <a href="http://menzies.us">Tim Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<img width=250 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy; 2020</a> by <a href="http://menzies.us">Tim Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<img width=250 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

<a name=top>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a>) ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a>) ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a>) ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a>) ::
[&copy;2020](http://github.com/timm/gold/blob/master/LICENSE.md#top) by <a href="http://menzies.us">Tim Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<img width=300 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

<a name=top>
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
