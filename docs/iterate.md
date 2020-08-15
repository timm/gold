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
function cols(use, file, out,    a,c,n) {
  if (!csv(a,file)) 
    return 0
  if (!length(use)) 
    for(c in a) 
      if (a[c] !~ /\?/)
        use[c] = ++n;
  split("",out,"")
  for(c in use)  
    out[ use[c] ] = a[c]
  return 1
}
```
