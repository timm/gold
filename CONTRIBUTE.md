<a name=top>&nbsp;<p>
<a href="https://github.com/timm/gold/blob/master/README.md#top">home</a> ::
<a href="https://github.com/timm/gold/blob/master/src/lib/README.md#top">lib</a> ::
<a href="https://github.com/timm/gold/blob/master/src/cols/README.md#top">cols</a> ::
<a href="https://github.com/timm/gold/blob/master/src/rows/README.md#top">rows</a> ::
<a href="http://github.com/timm/gold/blob/master/LICENSE.md#top">&copy;&nbsp;2020</a>&nbsp;by&nbsp;<a href="http://menzies.us">Tim&nbsp;Menzies</a>
<h1> GOLD = a Gawk Object Layer</h1>
<img width=250 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

## How to Contribute

Document your doce

Code is in .md files

Never add a level1 heading to your .md files

Start the file with a level2 heading

If you need sub-sections in the file, use level3 headings

Level4 headings are for functions or class definitions.

Level4 headings describe function arguments. They contain the following type hints.

- `atom` denotes type any atom (string or number)
- `any` denotes type any type (list or string or number)
- `nil` denotes nil
- `"x"`  denotes strings
- `x` denotes numbers (default tye)
- `x = y` denotes that x's default argument is y.
- `[x]` denotes list of x
- `?x` denotes optional argument
- `:x` denotes a suffix saying that something is of type x
- `:^x` denotes a suffix saying  that something is of  type any which is an indexes into some array containing x
- `+x`  notes  something that should arrive unassigned and while will become a list
- `Xx` (a word starting with uppercase) denotes that Xx is something created by the constructor Xx.

These can be combined

- `?["x"]` denotes an optional list of string
- `?x=y` denotes an  optional argument
