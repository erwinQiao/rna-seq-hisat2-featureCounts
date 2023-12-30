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
    conda:
        "../envs/fastqc.yaml"
    log:
        "logs/fastqc/{samples}{end}.log"
    threads:config["resources"]["fastqc"]["cpu"]
    shell:
        "fastqc -q -noextract  -t {threads} -o {params.outputpath} {input} 2>&1> {log}"
rule multiqc:
    input:
        expand("results/qc/fastqc/{samples}{end}_fastqc.zip", samples=SAMPLES, end = ["_R1","_R2"])
    output:
        directory("results/qc/multiqc_data"),
        "results/qc/multiqc_report.html"
    threads: config["resources"]["fastqc"]["cpu"]
    log:
        "logs/multiqc/multiqc.log"
    conda:
        "../envs/fastqc.yaml"
    params:
        outputpath = "results/qc/"
    shell:
        "multiqc --force -o {params.outputpath} {input} 2>&1> {log}"

    
