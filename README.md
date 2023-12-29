# RNA-seq (Hisat2-FeatureCounts-DeSeq2) based on Snakemake  

## Introduction

This Snakemake workflow is designed for the analysis of RNA-seq data (Hisat2-FeatureCounts-DeSeq2). It includes steps for quality control, read alignment, quantification, and differential expression analysis.  This workflow handles paired-end data. We used the data published by our previous data.  

If you use this workflow in a paper, don't forget to give credits to the authors by citing the URL of this (original) repository.  

## Overview  

The standard workflow performs the following steps:  

1. Quality control of raw reads using FastQC and aggregated report with MultiQC  
2. Trim reads with trim_galore  
3. Download the reference genome and gif  
4. Build HIAST2 index and align reads to reference genome
5. Quantify gene expression levels using FeatureCounts  
6. Merge all counts into a single file  
7. Normalize counts using TPM and FPKM  
8. Perform differential expression analysis using DeSeq2  

## Requirment  

### Install snakemake via Conda/Mamba  

Step1 Install conda/mamba  

1. Please carefully read the related docs in the miniconda web <https://docs.conda.io/projects/miniconda/en/latest/>  

2. Download the Linux or macOS files  
Linux x86_64 <https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh>  
Linux arch64 <https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh>  

3. install miniconda  

```{bash}
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
```

Step2 Install snakemake and conda enviroment  

```{bash}
# install mamba  
conda install -y -c conda-forge mamba  

# create the directory
mkdir snakemake
cd snakemake
git clone https://github.com/

# enviroment setting
mamba create -n snakemake --file enviroment.yaml  
```

### Run workflow  

Step1 Activate the conda enviroment

```{bash}
conda activate snakemake
```

Step2 Input samples.csv etal  
You need to verify if the data names, groups, and samples are consistent with sample.csv.  



Step2 Run workflow  

```{bash}
# set the cores nubmer by yourself

snakemake --cores number -s workflow/Snakefile --use-conda  
```

### Inverstagte results  
