samples = SAMPLES

rule trim_galore:
    input:
        fq1 = expand("reads/{samples}_R1.fastq.gz",samples=SAMPLES),
        fq2 = expand("reads/{samples}_R2.fastq.gz",samples=SAMPLES)
    output:
        fastq_fwd= "results/trimmed/{samples}_R1_val_1.fq.gz",
        report_fwd= "results/trimmed/{samples}_R1.fastq.gz_trimming_report.text",
        fastq_rev= "results/trimmed/{samples}_R2_val_1.fq.gz",
        report_rev= "results/trimmed/{samples}_R2.fastq.gz_trimming_report.text"

    params:
        phred = config["resources"]["trimming"]["phred"],
        extra = "--illumina -q 20",
        outputpath= "results/trimmed"

    threads:
        config["resources"]["trimming"]["cpu"]
    log:
        "logs/trim_galore/{sample}.log"

    conda:
        "envs/trim_galore.yaml"

    shell:
        "trim_galore --cores {threads} --paired {params.phred} {params.extra} -o {params.outputpath} 2> {log}"

rule rename:
    input:
        fastq_fwd= "results/trimmed/{samples}_R1_val_1.fq.gz",
        report_fwd= "results/trimmed/{samples}_R1.fastq.gz_trimming_report.text",
        fastq_rev= "results/trimmed/{samples}_R2_val_1.fq.gz",
        report_rev= "results/trimmed/{samples}_R2.fastq.gz_trimming_report.text"
    output:
        fastq_fwd= "results/trimmed/{samples}_R1.fastq.gz",
        report_fwd= "results/trimmed/{samples}_R1_trimming_report.text",
        fastq_rev= "results/trimmed/{samples}_R2.fastq.gz",
        report_rev= "results/trimmed/{samples}_R2_trimming_report.text"

    shell:
        "mv {input} {output} 2> {log}"