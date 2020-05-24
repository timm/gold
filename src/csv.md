<a name=top><img align=right width=400 src="https://github.com/timm/gold/blob/master/etc/img/coins.png">
<h1><a href="/README.md#top">GOLD: the GAWK object layer</a></h1> 
<p><a
href="https://github.com/timm/gold/blob/master/LICENSE.md#top">license</a> :: <a
href="https://github.com/timm/gold/blob/master/INSTALL.md#top">install</a> :: <a
href="https://github.com/timm/gold/blob/master/CODE_OF_CONDUCT.md#top">contribute</a> :: <a
href="https://github.com/timm/gold/issues">issues</a> :: <a
href="https://github.com/timm/gold/blob/master/CITATION.md#top">cite</a> :: <a
href="https://github.com/timm/gold/blob/master/CONTACT.md#top">contact</a></p><p><a 
href="https://doi.org/10.5281/zenodo.3841466"><img 
src="https://zenodo.org/badge/DOI/10.5281/zenodo.3841466.svg" alt="DOI"></a>
<img src="https://img.shields.io/badge/license-mit-red">   
<img src="https://img.shields.io/badge/language-gawk-orange">    
<img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
<img src="https://img.shields.io/badge/platform-mac,*nux-informational">
<a href="https://travis-ci.org/github/timm/gold"><img 
src="https://travis-ci.org/timm/gold.svg?branch=master"></a><br> <a
href="https://github.com/timm/gold/blob/master/doc/11classes.md#top">classes</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/12methods.md#top">methods</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/13testing.md#top">testing</a> :: <a
href="https://github.com/timm/gold/doc/14doco.md#top">doco</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/15tips.md#top">tips</a> :: <a
href="https://github.com/timm/gold/blob/master/doc/16examples.md#top">egs</a></p><br clear=all>


# CSV Reader

Standard GAWK can read simple comma seperated files. 
But what about CSV files with:

- comments, that should be stripped away?
- blank lines, that should be skipped?
- spurious white space, that should be deleted?
- records that break over multiple lines?

For example, here is a csv file where the first record is really
`name,age,shoesize`, there are comments and new lines and white
space to ignore, and the last record is split over multiple lines.

        name,     # clients name
        age,      # posint, 0..120
        shoesize
        #-------------------------
 
        tim,   21,  12
        susan, 22,  2132
        sarah,
               14,  101

This `csv` function can handle all that. Note that the second `file`
argument is optional and, if omitted, this code will read from
standard input.

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
Notes:

1. Defaults to standard input
2. Complains on missing input
3. At end of file, close this stream
4. If line ends in ",", combine this line with the next.
   Else....    
5. Kill whitespace and comments
6. Skip blank lines
7. Split line on "," into the array "a"

Example usage:

     function lintcsv(file,    row,n,want) 
        while(csv(row,file)) 
          if (++n == 1) 
            want = length(row) # row1 defines what we `want`
          else if (want != length(row)) 
            print "#E> row " n " wrong number of fields" 
     }
