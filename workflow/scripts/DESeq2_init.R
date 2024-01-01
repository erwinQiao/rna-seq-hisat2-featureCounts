
log<-file(snakemake@log[[1]], open="wt")
sink(log, type="output")
sink(log, type="message")

library(DESeq2)
library(tidyverse)

counts_data<-read.table(
  snakemake@input[["counts"]],
  header = T,
  row.names = "gene_id"
)
