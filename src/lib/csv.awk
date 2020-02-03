# vim: filetype=awk nospell ts=2 sw=2 sts=2 et :

# [1] Defaults to standard input
# [2] Complains on missing input
# [3] At end of file, close this stream
# [4] If file ends in ",", combine this line with the nxta
# [5] Kill whitespace and comments
# [6] Skip blank lines
# [7] Split line on "," into the array "a"

function csv(a,file,     b4, status,line) {
  file = file ? file : "-"            ## [1]
  status = getline < file
  if (status<0) {   
    print "#E> Missing file ["file"]" ## [2]
    exit 1 
  }
  if (status==0) {
    close(file)                       ## [3]
    return 0
  } 
  line = b4 $0                        ## [4]
  gsub("([ \t]*|#.*)", "", line)     ## [5]
  if (!line)                          ## [6]
    return csv(a,file, line)
  if (line ~ /,$/)                    ## [4]
    return csv(a,file,line)
  split(line, a, ",")                 ## [7]
  return 1
}
