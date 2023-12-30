log <- file(snakemake@log[1], open="wt")
sink(log)
sink(log, type = "message")

library(tidyverse)
library(ggplot2)

fpkm<-snakemake@input[["fpkm"]]
fpkm<-fpkm%>%
  column_to_rownames(var="gene_id")%>%
  drop_na()
condition<-rowSums(fpkm>0)>=floor(0.5*ncol(fpkm))
filter_fpkm<-fpkm[condition,]

#Violin
Violinpolt_fpkm<-ggplot(data=data,aes(x=sample,y=expression,fill=sample))+
  geom_violin(na.rm = T,alpha=0.5)+
  #异常点尺寸 outlier
  geom_boxplot(linetype=1,na.rm = T,outlier.shape = NA,
               notch = T,width=0.3,outlier.fill = NULL,alpha = 0.5)+
  xlab("Sample")+ylab("log2(FPKM+1)")+
  theme(axis.text = element_text(size=rel(1)),
        axis.line=element_line(size=rel(1.2)),
        axis.title = element_text(size=rel(1.5)),
        panel.background = element_blank(),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12))+
  ylim(0,max(data$expression)*0.3)

ggsave("ViolinplotFPKM.pdf",Violinpolt_fpkm, path = snakemake@params[["outputpath"]])