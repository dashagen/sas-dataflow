#!/usr/local/bin/Rscript

require(igraph);
require(tcltk);

file.name <- commandArgs()[6]

edges <- read.csv(file.name,header=F);

ig <- graph.data.frame(edges) %>%
        set_vertex_attr("color", value="gray") %>%
        set_edge_attr("color", value="black")

tt <- tktoplevel()

w <- tkplot(ig)

tkconfigure(igraph:::.tkplot.get(w)$canvas, "bg" = "white")


tkwait.window(tt)

