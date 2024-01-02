log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(tidyverse)
library(ggplot2)
library(ggrepel)
library(ggsci)

TPM<-read.table(snakemake@input[["TPM"]], header=TRUE, row.names=1)

pca<-as.data.frame(t(TPM))%>%
  mutate(samples=colnames(TPM))

pca_1<-prcomp(pca[,-ncol(pca)])
summ1<-summary(pca_1)

df<-as.data.frame(pca_1$x)
xlab1 <- paste0("PC1(",round(summ1$importance[2,1]*100,2),"%)")
ylab1 <- paste0("PC2(",round(summ1$importance[2,2]*100,2),"%)")

pdf(snakemake@output[[1]])
ggplot(data = df,aes(x = PC1,y = PC2))+
  geom_point(size = 2.5,aes(color = pca$samples))+
  labs(x = xlab1,y = ylab1,color = "Condition",title = "PCA Scores Plot")+
  guides(fill = "none")+
  theme(plot.title = element_text(hjust = 0.5,size = 15),
        axis.text = element_text(size = 11),axis.title = element_text(size = 13),
        legend.text = element_text(size = 11),legend.title = element_text(size = 13),
        plot.margin = unit(c(0.4,0.4,0.4,0.4),'cm'))+
  theme_bw()+
  geom_label_repel(aes(label=pca$samples))
dev.off()