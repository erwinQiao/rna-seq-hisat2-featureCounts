samples = SAMPLES

rule trim_galore:
    input:
        ["reads/{samples}_R1.fastq.gz", "reads/{samples}_R2.fastq.gz"],
    output:
        fastq_fwd= "results/trimmed/{samples}_R1_val_1.fq.gz",
        report_fwd= "results/trimmed/{samples}_R1.fastq.gz_trimming_report.txt",
        fastq_rev= "results/trimmed/{samples}_R2_val_2.fq.gz",
        report_rev= "results/trimmed/{samples}_R2.fastq.gz_trimming_report.txt"

    params:
        phred = config["resources"]["trimming"]["phred"],
        extra = "--illumina -q 20",
        outputpath= "results/trimmed"

    threads:
        config["resources"]["trimming"]["cpu"]
    log:
        "logs/trim_galore/{samples}.log"

    conda:
        "../envs/trim_galore.yaml"

    shell:
        "trim_galore --cores {threads} --paired {params.phred} {params.extra} {input[0]} {input[1]} -o {params.outputpath} 2> {log}"

rule rename:
    input:
        fastq_fwd= "results/trimmed/{samples}_R1_val_1.fq.gz",
        report_fwd= "results/trimmed/{samples}_R1.fastq.gz_trimming_report.txt",
        fastq_rev= "results/trimmed/{samples}_R2_val_2.fq.gz",
        report_rev= "results/trimmed/{samples}_R2.fastq.gz_trimming_report.txt"
    output:
        fastq_fwd= "results/trimmed/{samples}_R1.fastq.gz",
        report_fwd= "results/trimmed/{samples}_R1_trimming_report.txt",
        fastq_rev= "results/trimmed/{samples}_R2.fastq.gz",
        report_rev= "results/trimmed/{samples}_R2_trimming_report.txt"

    shell:
        """
        mv {input.fastq_fwd} {output.fastq_fwd} && \\
        mv {input.report_fwd} {output.report_fwd} && \\
        mv {input.fastq_rev} {output.fastq_rev} && \\
        mv {input.report_rev} {output.report_rev}
        """