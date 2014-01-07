#!/usr/bin/Rscript

require(igraph);
require(tcltk);

file.name <- commandArgs()[6]

edges <- read.csv(file.name,header=F);

ig <- graph.data.frame(edges);

tt <- tktoplevel()

w <- tkplot(ig)

tkwait.window(tt)

