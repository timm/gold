[home](https://github.com/timm/gold/blob/master/README.md) ::
[lib](https://github.com/timm/gold/blob/master/src/lib/README.md) ::
[cols](https://github.com/timm/gold/blob/master/src/cols/README.md) ::
[rows](https://github.com/timm/gold/blob/master/src/rows/README.md) ::
[&copy;2020](http://github.com/timm/gold/blob/master/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = a Gawk Object Layer
<img  width=300 src="https://raw.githubusercontent.com/timm/gold/master/etc/img/auk.png">

[home](http://github.com/timm/gold/README.me) ::
[lib] ::
[cols] ::
[rows] ::
[&copy; 2020](http://github.com/timm/gold/LICENSE.md) by [Tim Menzies](http://menzies.us)   
# GOLD = the Gawk Object Layer
----- 

 <h1 align=center> Gold = Gawk object layer</h1>
  <p align=center>
   <img src="https://pngimg.com/uploads/gold/gold_PNG11033.png">
 <br clear=all>
  <a 		                      width=15   src="https://image.flaticon.com/icons/svg/25/25621.svg"> <a 
 href="#features">features</a> ::  <a  <a 
 href="#citation">cite</a> ::  <a 
 href="#install">install</a> :: <a 
 href="#contact">contact</a> :: <a 
 href="#license">license</a>    </a>  
 </p>

 ## Features
 
Gold is a transpiler that converts `.md` files containg `awk` blocks into awk code. Dots are translated into
array references. E.g.

    a.b.c++
    
becomes

    a["b"]["c"]++
    
Along the way, other things are added in like:

- encapsulation (using the dots), 
- polymorphism and inheritance (using indirect functions), 
- iterators and unit tests (using some built in fuctions)
- document generation (using the `.md` files stores in a `docs` directory which can be used by, e.g. Jekyll).

## Citation

## Install

- Download [gold.sh](gold.sh) to an empty directory.
- Run `sh gold.sh --install`
- Run `sh gold.sh --tests` 
  - You should see only one failure (when we test the test suite).

## License

Copyright 2020 Tim Menzies

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject
to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
