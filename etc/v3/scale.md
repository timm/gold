# SCALE: StoChAstic LandscapE analysis

(c) 2020 MIT License, Tim Menzies timm@ieee.org   
Optimization via discretization and contrast sets.

Definition SCALE (v):

-   To climb up or reach by means of a ladder;
-   To attack with or take by means of scaling ladders;
-   To reach the highest point of (see also SURMOUNT).

              _    .  ,   .           .
              *  / \_ *  / \_      .  *        *   /\'__        *  
                /    \  /    \,             .    _/  /  \  *'.    
           .   /\/\  /\/ :' __ \_  `          _^/  ^/    `--.  
              /    \/  \  _/  \-'\      *    /.' ^_   \_   .'\  *  
            /\  .-   `. \/     \ /==~=-=~=-=-;.  _/ \ -. `_/   \   
           /  `-.__ ^   / .-'.--\ =-=~_=-=~=^/  _ `--./ .-'  `-  
          /jgs     `.  / /       `.~-^=-=~=^=.-'      '-._ `._  

"I think the highest and lowest points are the important ones. 
 Anything else is just... in between."    
-- Jim Morrison

## Specification

- input -->  rows of `X`+,`Y`+  
  -  `X` --> `num`|`skip`|`sym`   marked `:`|`?`|`_` respectively
  - `Y` --> minimize|maximize marked `<`|`>` respectively
  - (and these marks appear in row1 of the data)
- output = `rule`+
  - `rule` --> `Range`+ _score_
  - `Range` --> 
    - `X` _value_ (for `sym` columns) 
    -  `X` _lo hi_ (for `num` columns)


