#<a name=top>&nbsp;<p>
#<a href="https://github["com"]/timm/gold/blob/master/README["md"]#top">home</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/lib/README["md"]#top">lib</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/cols/README["md"]#top">cols</a> ::
#<a href="https://github["com"]/timm/gold/blob/master/src/rows/README["md"]#top">rows</a> ::
#<a href="http://github["com"]/timm/gold/blob/master/LICENSE["md"]#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies["us"]">Tim&nbsp;Menzies</a>
#<h1> GOLD = a Gawk Object Layer</h1>
#<img width=250 src="https://raw["githubusercontent"]["com"]/timm/gold/master/etc/img/auk["png"]">
#
### Files
#

function csv(a,file,     i,j,b4, ok,line,x,y) {
  file  = file ? file : "-"           
  ok = getline < file
  if (ok <0) { print "missing "file > "/dev/stderr"; exit 1 }
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
