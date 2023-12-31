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

### Install conda/miniconda  

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

### Install snakemake using mamba/conda

1. Install snakemake and conda enviroment  

```{bash}
# install mamba  
conda install -y -c conda-forge mamba  

# create the directory
mkdir snakemake
cd snakemake
git clone https://github.com/erwinQiao/rna-seq-hisat2-deseq2.git

```

2. Install the required snakemake  

```{bash}
# install snakemake via mamba
mamba create -c conda-forge -c bioconda -n snakemake snakemake 

# install snakemake via conda
conda create -c conda-forge -c bioconda -n snakemake snakemake

# activate the conda enviroment
conda activate snakemake
```

### Run workflow  

Step1 Activate the conda enviroment

```{bash}
conda activate snakemake

# checke snakemake version
snakemake --version
snakemake -v
```

**Attention: Syntax for Conda has changed in Snakemake 8.0 and later!**

In the new versions of Snakemake, the syntax for using Conda environments has been adjusted. Please check the help:

`snakemake --help`

Step2 Input samples.csv etal  
You need to verify if the data names, groups, and samples are consistent with sample.csv.  


Step3 Run workflow  

```{bash}
# set the cores nubmer by yourself

snakemake --cores number -s workflow/Snakefile --use-conda  
```

Step4 Rerun  

if you accidentally interrupt the program and have unfinished tasks, you can use the following command to resume the execution and ensure that the incomplete tasks are successfully completed:  

`snakemake --cores 90 --use-conda -s workflow/Snakefile --rerun-incomplete`  

## Inverstagte results  

### Check the process  

When you run the workflow, you can see the process of the workflow in the terminal.  

```{text}
Job stats:  
job                      count
------------------------  -------
all                             1  
fastqc                         12  
featuresCounts                  6  
get_ensembl_genome_fasta        1  
get_ensembl_gtf                 1  
hisat2                          6  
hisat2_ensembl_index            1  
mergeCounts                     1  
multiqc                         1  
rename                          6  
trim_galore                     6  
total                          42  
```

If you have resources, you can skip the steps of downloading the genome and building the index during the process, thus reducing both space and time. However, you must ensure that the files are complete.  

```{text}
Job stats:  
job                     count  
--------------------  -------
all                         1  
fastqc                     30  
featuresCounts             15  
hisat2                     15  
hisat2_ensembl_index        1  
mergeCounts                 1  
multiqc                     1  
rename                     15  
trim_galore                15  
total                      94  
```

