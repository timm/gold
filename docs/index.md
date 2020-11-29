
#  cluster.gold
  - [Cluster](cluster.md#cluster) : Recursively split the data using two distant points.
    - [Cluster](cluster.md#cluster) : Constructor for a tree of clusters
    - [_Div](cluster.md#_div) : Divide the data 
    - [_Project](cluster.md#_project) : Return how far `r` falls between `i.lo` and `i.hi`. 
    - [_Print](cluster.md#_print)

#  col.gold
  - [Abstract class: parent of all column](col.md#abstract-class-parent-of-all-column)
    - [Col](col.md#col) : Abstract constructor for our column.
    - [add](col.md#add) : Polymorphic update function for columns.
    - [adds](col.md#adds) : Add many things
    - [dist](col.md#dist) : Distance between things.
  - [Columns to be ignored.](col.md#columns-to-be-ignored)
    - [Info](col.md#info) : Constructor for columns we will not summarize. 
    - [_Add](col.md#_add) : Do nothing.
  - [Summaries of columns of symbols](col.md#summaries-of-columns-of-symbols)
    - [Sym](col.md#sym) : Constructor for summary of symbolic columns.
    - [_Add](col.md#_add) : Update frequency counts, and `mode`.
    - [_Dist](col.md#_dist) : Distance calcs for `Sym`bols.
  - [Summaries of columns of numbers](col.md#summaries-of-columns-of-numbers)
    - [Num](col.md#num) : Constructor of summary of numeric columms
    - [_Add](col.md#_add) : Update self, return `x`.
    - [_Pdf](col.md#_pdf) : Return height of the Gaussian at `x`.
    - [_Cdf](col.md#_cdf) : Return the area under the Gaussian from negative infinity to `x`.
    - [_Crossover](col.md#_crossover) : Return where two Gaussians cross in-between their means.
    - [_Norm](col.md#_norm) : Distance calcs for `Num`bols.
    - [_Dist](col.md#_dist) : Return normalized distance 0..1 between two numbers `x` and `y`.

#  contrast.gold
- [vim: ft=awk ts=2 sw=2 et :](contrast.md#vim-ftawk-ts2-sw2-et-)
  - [bore](contrast.md#bore)
  - [dominates](contrast.md#dominates)

#  lib.gold
  - [Globals](lib.md#globals) : There is only one.
    - [BEGIN { List](lib.md#begin--list)
  - [Object stuff](lib.md#object-stuff) : Methods for handling objects.
    - [List](lib.md#list) : Initialize an empty list
    - [Object](lib.md#object) : Initialize a new object, give it a unique id (in `i.id`)
    - [has](lib.md#has) : Create something of class `f` inside of `i` at position `k`
    - [haS](lib.md#has) : Like `has`, but has 1 constructor argument `x`.
    - [hAS](lib.md#has) : Like `has`, but has 2 constructor arguments `x` and `y`..
    - [HAS](lib.md#has) : Like `has`, but has 3 constructor arguments `x`,`y` and `z`..
    - [HASS](lib.md#hass) : Like `has`, but has 4 constructor arguments `w,x,y,z`.
    - [new](lib.md#new) : Add a new instances of class `f` at the end of `i`.
    - [asNum](lib.md#asnum) : If `x` can be coerced number, return that. Else return `x`.
  - [Testing stuff](lib.md#testing-stuff) : Support for unit testing.
    - [rogues](lib.md#rogues) : Print local variables, escaped from functions
    - [tests](lib.md#tests) : Run the functions names in the comma-separated string `s`.
    - [ok](lib.md#ok) : Print "PASS" if `got` same as `want1` (and print "FAIL" otherwise).
    - [red](lib.md#red)
  - [Array stuff](lib.md#array-stuff) : Support for managing arrays.
    - [push](lib.md#push) : Return `x` after adding to the end of `a`.
    - [keysort](lib.md#keysort) : Sort `a` by field `k`.
    - [keysort1](lib.md#keysort1)
    - [sortCompare](lib.md#sortcompare)
    - [copy](lib.md#copy) : `b` is set to a recursively copy of `a`.
    - [copy2end](lib.md#copy2end) : Append nested list `a to position length+1 of `b`
  - [String stuff](lib.md#string-stuff)
    - [nc](lib.md#nc) : Return a string of length `n` containing character `s`.
  - [Maths stuff](lib.md#maths-stuff) : Some mathematical details.
    - [abs](lib.md#abs) : Return absolute value of `x`.
    - [max](lib.md#max) : Return max of `x` and `y.
    - [min](lib.md#min) : Return min of `x` and `y.
    - [z](lib.md#z) : Sample from a Gaussian.
    - [asd](lib.md#asd) : Return standard deviation of those nums.
    - [div](lib.md#div)
    - [div1](lib.md#div1)
    - [bin](lib.md#bin)
    - [Printing stuff](lib.md#printing-stuff)
      - [o](lib.md#o) : Simple printing of a flat array
      - [oo](lib.md#oo)
      - [ooSortOrder](lib.md#oosortorder)
  - [File stuff](lib.md#file-stuff)
    - [csv](lib.md#csv) : Loop over a csv file `f`, setting the array `a` to the next record.

#  ranges.gold

#  rows.gold
  - [Row](rows.md#row) : Storage for one row of data.
    - [Row](rows.md#row) : Constructor
    - [_Dist](rows.md#_dist) : Distance between two rows
  - [Rows](rows.md#rows) : Storage for many rows of data, with summaries of the columns.
    - [Rows](rows.md#rows) : Constructor
    - [_Load](rows.md#_load) : Load a csv file `f` into the table `i`
    - [_Add](rows.md#_add) : Update `i` with `a`. First update creates the column headers.
    - [_Header](rows.md#_header) : Initialize columns in a table.
    - [_Data](rows.md#_data) : Add an row at some random index within `rows`.
    - [_Dist](rows.md#_dist) : Distance between two rows.
    - [_Far](rows.md#_far) : Return something quite far way from `r` (ignoring outliers).
    - [_Around](rows.md#_around) : Compute `out`; i.e.  pairs <row,d> listing neighbors of `r1`.
    - [_Clone](rows.md#_clone) : Copy the structure of table `i` into a new table `j`.
    - [_Y](rows.md#_y)
    - [_Sample](rows.md#_sample) : Set `a` to a sample of `enough` rows from column `c`.
    - [_Bins](rows.md#_bins) : Discretize all numeric columns in each row's `bins`.
    - [_Bin](rows.md#_bin) : Discretize one column of numeric values in each row's `bins`.
    - [_BinsHeader](rows.md#_binsheader) : Return a header where all the independent columns are not numbers
    - [_SomeBins](rows.md#_somebins) : Add a new table to `out` with discretized values for some rows. 

#  stat.gold
- [Incremental calculator for accuracy, precion, recall, etc](stat.md#incremental-calculator-for-accuracy-precion-recall-etc) : e.g.
  - [Abcd](stat.md#abcd)
  - [_Adds](stat.md#_adds)
  - [_Report](stat.md#_report)

#  tests.gold
- [vim: ft=awk ts=2 sw=2 et :](tests.md#vim-ftawk-ts2-sw2-et-) : @include "lib"
  - [csv1](tests.md#csv1)
  - [tab0](tests.md#tab0)
  - [tab1](tests.md#tab1)
  - [zs](tests.md#zs)
  - [dists1a](tests.md#dists1a)
  - [far1](tests.md#far1)
  - [oo1](tests.md#oo1)
  - [cluster1](tests.md#cluster1)
- [print "better" RowsY(cl.leaves[i])](tests.md#print-better-rowsyclleavesi) :  #          print "worse"  RowsY(cl.leaves[j])
  - [BEGIN{](tests.md#begin)
