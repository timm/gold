<a name=top><img align=right width=400 src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<h1 align=left><a href="/README.md#top">GOLD: the GAWK object layer</a></h1> 
<p align=left> <a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a><br><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a></p><br clear=all>


# CSV Reader

1. Defaults to standard input
2. Complains on missing input
3. At end of file, close this stream
4. If file ends in ",", combine this line with the next.
   Else....    
5. Kill whitespace and comments
6. Skip blank lines
7. Split line on "," into the array "a"

```awk   
function csv(a,file,     b4, status,line) {
  file   = file ? file : "-"           # [1]
  status = getline < file
  if (status<0) {   
    print "#E> Missing file ["file"]"  # [2]
    exit 1 
  }
  if (status==0) {
    close(file) 
    return 0
  }                                    # [3]
  line = b4 $0                         # [4]
  gsub(/([ \t]*|#.*$)/, "", line)      # [5]
  if (!line)       
    return csv(a,file, line)           # [6]
  if (line ~ /,$/) 
    return csv(a,file, line)           # [4]
  split(line, a, ",")                  # [7]
  return 1
}
```
