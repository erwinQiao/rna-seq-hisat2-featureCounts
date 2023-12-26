samples = SAMPLES,
end = ["_R1","_R2"]

rule fastqc:
    input:
        "reads/{samples}{end}.fastq.gz"

    output:
        html = "results/qc/fastqc/{samples}{end}_fastqc.html",
        zip = "results/qc/fastqc/{samples}{end}_fastqc.zip"
    params:
        outputpath = "results/qc/fastqc/"

    threads: config["resources"]["fastqc"]["cpu"]

    log:
        "logs/fastqc/{samples}{end}.log"

    threads:config["resources"]["fastqc"]["cpu"]

    shell:
        "fastqc -noextract  -t {threads} -o {params.outputpath} {input} > {log}"


rule multiqc:
    input:
        expand("results/qc/fastqc/{samples}{end}_fastqc.zip", samples=SAMPLES, end = ["_R1","_R2"])

    output:
        "results/qc/multiqc_data/multiqc_general_stats.txt",
        "results/qc/multiqc.html"

    threads: config["resources"]["fastqc"]["cpu"]

    log:
        "log/multiqc/multiqc.log"
    params:
        outputpath = "results/qc"

    shell:
        "multiqc --force -o {params.outputpath} {input}"

    
