log<-file(snakemake@log[[1]],open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)

samples<-snakemake@input[["dataCounts"]]

# sample name

samples_name<-tools::file_path_sans_ext(samples)
samples_name <- sub(".*/([^/]+)$", "\\1", samples_name)

data<-lapply(samples, function(name){
    read_table(file = name)
})
names(data)<-samples_name

merged_data <- reduce(data, full_join, by = "gene_id")

# count
count<- merged_data%>%
  select(gene_id = "gene_id",matches("^count"))
colnames(count)<-c("gene_id",samples_name)

# fpkm
fpkm<- merged_data%>%
  select(gene_id = "gene_id",matches("^fpkm"))
colnames(fpkm)<-c("gene_id",samples_name)
#tpm
tpm<- merged_data%>%
  select(gene_id = "gene_id",matches("^tpm"))
colnames(tpm)<-c("gene_id",samples_name)

write.table(count, file = snakemake@output[["counts"]],col.names=TRUE, row.names=FALSE, quote=FALSE)
write.table(fpkm, file = snakemake@output[["FPKM"]],col.names=TRUE, row.names=FALSE, quote=FALSE)
write.table(tpm, file =snakemake@output[["TPM"]],col.names=TRUE, row.names=FALSE, quote=FALSE)



