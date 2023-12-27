# featureCounts

library(Rsubread)
library(limma)
library(edgeR)

bamFile <- snakemake@input[['bam']]
gtfFile <- snakemake@input[['gtf']]
nthreads <- snakemake@threads
outStatsFilePath <- snakemake@output[['logfile']]
outCountsFilePath < -snakemake@output[['count_output']]

# subread
fCountsList = featureCounts(bamFile, annot.ext=gtfFile, isGTFAnnotationFile=TRUE, nthreads=nthreads, isPairedEnd=TRUE)

#edgeR
dgeList = DGEList(counts=fCountsList$counts, genes=fCountsList$annotation)

fpkm = rpkm(dgeList, dgeList$genes$Length)

tpm = exp(log(fpkm) - log(sum(fpkm)) + log(1e6))

write.table(fCountsList$stat, outStatsFilePath, sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)

featureCounts = cbind(fCountsList$annotation[,1], fCountsList$counts, fpkm, tpm)

colnames(featureCounts) = c('gene_id', 'counts', 'fpkm','tpm')

write.table(featureCounts, outCountsFilePath, sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
