log<-file(snakemake@log[[1]],open="wt")
sink(log)
sink(log, type="message")

library(Rsubread)
library(limma)
library(edgeR)

bamFile <-snakemake@input[["bam"]]
gtfFile <-snakemake@input[["gtf"]]
outFilePref <- snakemake@params[["outdir"]]
nthreads<-10

outCountsFilePath <- paste(outFilePref, '.count', sep = '');

fCountsList = featureCounts(bamFile, annot.ext=gtfFile, isGTFAnnotationFile=TRUE, nthreads=nthreads, isPairedEnd=TRUE)
dgeList = DGEList(counts=fCountsList$counts, genes=fCountsList$annotation)
fpkm = rpkm(dgeList, dgeList$genes$Length)
tpm = exp(log(fpkm) - log(sum(fpkm)) + log(1e6))

featureCounts = cbind(fCountsList$annotation[,1], fCountsList$counts, fpkm, tpm)
colnames(featureCounts) = c('gene_id', 'counts', 'fpkm','tpm')
write.table(featureCounts, outCountsFilePath, sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

