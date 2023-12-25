samples = SAMPLES,
end = ["_R1","_R2"]

rule fastqc:
    input:
        "reads/{samples}{end}.fastq.gz"

    output:
        html = "results/qc/fastqc/{samples}{end}.html",
        zip = "results/qc/fastqc/{samples}{end}_fastqc_zip"
    params:
        extra = "--quiet",
        outputpath = "results/qc/fastqc/"

    threads: config["resources"]["fastqc"]["cpu"]

    log:
        "logs/fastqc/{samples}{end}.log"

    threads:config["resources"]["fastqc"]["cpu"]

    shell:
        "fastqc --noextract {params.extra} -t {threads} -o {params.outputpath} {input}  2> {log}" 


rule multiqc:
    input:
        expand("results/qc/fastqc/{samples}{end}_fastqc_zip", samples=SAMPLES, end = ["_R1","_R2"])
    
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

    
