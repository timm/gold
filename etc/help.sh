grep -E '^[a-zA-Z][^:]*:.*?## .*$' $* |
sort | 
awk 'BEGIN {
   FS = ":.*?## "
   C1=31
   C2=36
   printf("\n\033["C1"mmake [OPTION]\033[0m\n")
   FMT="\033["C2"m%-15s\033[0m"
} 
{printf "\t"FMT ": %s\n", $1, $2}'
