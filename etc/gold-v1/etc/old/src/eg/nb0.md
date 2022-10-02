<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies.us">Tim&nbsp;Menzies</a>
<img width=250 align=right src="http://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">
<h1> GOLD = a Gawk Object Layer</h1>
<em>A <a href="https://en.wikipedia.org/wiki/Little_auk">little <strike>auk</strike> awk</a>  goes a long way.</em><br>

## Naive Bayes
Basic Naive Bayes

```awk
@include "/../lib/oo"
@include "/../lib/list"
@include "/../lib/file"
@include "/../stats/abcd"

func Cols(i) { 
  i.is="Cols"
  i.class=""
  has(i,"txt");has(i,"all");has(i,"x");has(i,"y")}

func _Add(i,a,      c,x) {
  for(c in a) {
    x = a[c]
    if(x ~ /\?/) continue 
    i.txt[c] = x
    if(x ~ /!/) i.class = c
    i.all[c]
    (x ~ /[!<>]/) ? i.y[c] : i.x[c] }}

func Nb(i,f) {
   i.is = "Nb"
   i.Min   = 5  # tuning param
   i.K     = 2  # tuning param
   i.M     = 1  # tuning param
   i.file  = f  # data source (if empty string, then stdin)
   i.nall  = 0  # total rows seen
   has(i, "cols", "Cols")
   has(i, "seen")        # counts for each class
   has(i, "log", "Abcd")}# used to record performance

func _Add(i,row,  x,y,c,want,got) {
  ++i.nall
  y = row[i.cols.class]
  if (i.nall > i.Min)  
    @Add(i.log, y, _MostLiked(i,row))
  for(c in i.cols.all) {
    x = row[c]
    if(x != "?")    
      ++i.seen[y][c][x] }}

func _Like(i,row,y, n,    prior,like,c,x,f) {
  prior = like = (n + i.K)/(i.nall + i.K*length(i.seen))
  like  = log(like)
  for(c in i.cols.x) {
      x = row[c]
      if(x != "?") {
        f = i.seen[y][c][x] 
        like +=  log((f + i.M*prior) / (n + i.M)) }}
  return like }

func _MostLiked(i,row,     y,like,most,out) {
  most = -10^32
  for(y in i.seen) {
    out = out ? out : y
    like = _Like(i, row, y, i.seen[y][i.cols.class][y])
    if (like > most) {
      most = like
      out  = y }}
  return out }   

func _Read(i,     row) {
  csv(row, i.file) 
  @Add(i.cols, row)
  while (csv(row, i.file))  
    @Add(i, row) }
```
