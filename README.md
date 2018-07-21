# A Solution to visualize data flows in SAS codes


1. Run **ssDF.pl** to get data flows ( [from, to] pairs ).

    ```% ssDF.pl XXX.sas > XXX.edges```


2. Run **drawDF.R** to visualize data flows.

   ```% drawDF.R XXX.edges```

Note: drawDF.R requires [igraph](http://igraph.org/r/) and [tcltk](https://cran.r-project.org/web/packages/tcltk2/index.html) packages.

For a use case, please visit the [wiki](https://github.com/dashagen/sas-dataflow/wiki) page. 
