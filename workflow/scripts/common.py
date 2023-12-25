import pandas as pd
import sys
import glob
import os

def input_samples():
    try:
        csv = pd.read_csv("config/sample.csv")
        SAMPLES = csv["Sample"]
        fastq_R1 = csv["fastq_R1_filename"]
        fastq_R2 = csv["fastq_R2_filename"]
        
        for sample in SAMPLES:
            r1 = f"reads/{sample}_R1.fastq.gz"
            r2 = f"reads/{sample}_R2.fastq.gz"
    
            assert any(os.path.isfile(x) for x in [r1,r2]),f"ERROR: one fastq file not found in reads dir"
        return SAMPLES  

    except FileNotFoundError:
        print("ERROR: config/sample.csv not found")
        sys.exit(1)
    

