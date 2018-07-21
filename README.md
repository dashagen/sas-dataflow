# A Solution to visualize data flows in SAS codes


1. Run **ssDF.pl** to get data flows ( [from, to] pairs ).

    ```% ssDF.pl XXX.sas > XXX.edges```


2. Run **drawDF.R** to visualize data flows.

   ```% drawDF.R XXX.edges```

Note: drawDF.R requires **igraph** and **tcltk** packages.

For example please visit the [wiki](https://github.com/dashagen/sas-dataflow/wiki) page 
