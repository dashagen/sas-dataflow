# A Solution to visualize data flow in SAS codes

## Usage 
1. Suppose we have a piece of SAS code called `ex.sas`, we first run `ssDF.pl` to get the data flow information ( [from, to] pairs) and pass to a file (`ex.edges`).
  
  ```
  % ssDF.pl ex.sas > ex.edges
  ```
  
  `ex.edges` looks like
  
  ```
   a1,a2
   a2,a2(2)
   a1,a3
   a2(2),a3
   a3,p1
   a3,p2
   ```
2. We then run `drawDF.R` to visualize the data flow
   
   ```%drawDF.R ex.edges```
  * A window will pop up with a raw diagram of the data flow
<img src=raw.png><br><br>

  * You can re-arrange the vertexes and edges to make it look better<br><br><img src=https://raw.github.com/dashagen/sas-dataflow/master/after.png>
  
Note: drawDF.R requires [igraph](http://igraph.org/r/) and [tcltk](https://cran.r-project.org/web/packages/tcltk2/index.html) packages.

For a use case, please visit the [wiki](https://github.com/dashagen/sas-dataflow/wiki) page. 
