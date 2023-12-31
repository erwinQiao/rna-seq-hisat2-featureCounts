log<-file(snakemake@log[[1]],open="wt")
sink(log)
sink(log, type="message")


library(DESeq2)
library(tidyverse)

