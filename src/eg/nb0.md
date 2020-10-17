## Naive Bayes
Basic Naive Bayes

```awk
@include "/../lib/oo"
@include "/../lib/list"
@include "/../lib/file"
@include "/../stats/abcd"

func Nb(i,f) {
   i.Min   = 10          # tuning param
   i.K     = 1           # tuning param
   i.M     = 2           # tuning param
   i.file  = f           # data source (if empty string, then stdin)
   i.head  = ""          # names of columns 
   i.class = 0           # local class column
   i.nall  = 0           # total rows seen
   has(i, "seen")        # counts for each class
   has(i, "log", "Abcd")}# used to record performance

func _Add(i,row,  x,y,c) {
  y = row[i.class]
  if (++i.nall > i.Min) 
    AbcdAdd(i.log, y, _MostLiked(i,row))
  for(c in row) {
    x = row[c]
    if(x != "?")    
      ++i.seen[y][c][x] }}

func _Like(i,row,y,n,    prior,like,c,x,f) {
  prior = like = (n + i.K)/(i.nall + i.K*length(i.seen))
  like  = log(like)
  for(c in row)
    if(c != i.class) {
      x = row[c]
      if(x != "?") {
        f = i.seen[y][c][x] 
        like += log( (f + i.M*prior) / (n + i.M)) }}
  return like }

func _MostLiked(i,row,     y,like,most,out) {
  for(y in i.seen) {
    like = _Like(i, row, y, i.seen[y][i.class][y])
    if (like > most) {
      most=like
      out=y }}
  return out }   

func _Read(i,     row) {
  csv(row,  i.file) 
  i.class = length(row)
  while (csv(row, i.file)) 
    _Add(i, row) }
```
