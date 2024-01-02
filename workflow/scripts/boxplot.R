log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type = "message")

library(tidyverse)
library(ggplot2)

# file path
filepath = snakemake@input[["fpkm"]]

# read fpkm
fpkm<-read.table(filepath,header=T)
fpkm<-fpkm%>%
  column_to_rownames(var="gene_id")%>%
  drop_na()
condition<-rowSums(fpkm>0)>=floor(0.5*ncol(fpkm))
filter_fpkm<-fpkm[condition,]

# data
data1<-as.matrix(log2(filter_fpkm+1))
data<-data.frame(expression=c(data1),
                 sample=(rep(colnames(data1),each=nrow(data1))))

# Violin
Violinpolt_fpkm<-ggplot(data=data,aes(x=sample,y=expression,fill=sample))+
  geom_violin(na.rm = T,alpha=0.5)+
  #异常点尺寸 outlier
  geom_boxplot(linetype=1,na.rm = T,outlier.shape = NA,
               notch = T,width=0.3,outlier.fill = NULL,alpha = 0.5)+
  xlab("Sample")+ylab("log2(FPKM+1)")+
  theme(axis.text = element_text(size=rel(0.1*ncol(filter_fpkm))),
        axis.line=element_line(size=rel(0.1*ncol(filter_fpkm))),
        axis.title = element_text(size=rel(0.1*ncol(filter_fpkm))),
        panel.background = element_blank(),
        axis.title.x = element_text(size = ncol(filter_fpkm)),
        axis.title.y = element_text(size = ncol(filter_fpkm)),
        legend.position = "none")+
  ylim(0,max(data$expression)*0.3)

ggsave(snakemake@output[[1]], Violinpolt_fpkm,width = 1.2*ncol(filter_fpkm),
       height = 0.8*ncol(filter_fpkm))