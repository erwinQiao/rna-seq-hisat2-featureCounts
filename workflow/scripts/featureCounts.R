library(Rsubread)
library(limma)
library(edgeR)

bamFile <-snakemake@input[["bam"]]
gtfFile <-snakemake@input[["gtf"]]
outFilePref <- snakemake@output[["count_output"]]
nthreads<-10

outStatsFilePath  <- paste(outFilePref, '.log',  sep = '');
outCountsFilePath <- paste(outFilePref, '.count', sep = '');

fCountsList = featureCounts(bamFile, annot.ext=gtfFile, isGTFAnnotationFile=TRUE, nthreads=nthreads, isPairedEnd=TRUE)
dgeList = DGEList(counts=fCountsList$counts, genes=fCountsList$annotation)
fpkm = rpkm(dgeList, dgeList$genes$Length)
tpm = exp(log(fpkm) - log(sum(fpkm)) + log(1e6))

write.table(fCountsList$stat, outStatsFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)

featureCounts = cbind(fCountsList$annotation[,1], fCountsList$counts, fpkm, tpm)
colnames(featureCounts) = c('gene_id', 'counts', 'fpkm','tpm')
write.table(featureCounts, outCountsFilePath, sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

