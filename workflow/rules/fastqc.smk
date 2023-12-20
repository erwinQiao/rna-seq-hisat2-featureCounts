rule fastqc:
    input:
        "reads/{sample}{end}.fast.gz"

    output:
        html="results/qc/fastqc/{sample}{end}.html"
        zip="results/qc/fastqc/{sample}{end}_fastqc.zip" 
    params:
        extra = "--quiet"
    
    log:
        "logs/fastqc/{sample}{end}.log"
    threads:config["resources"]["fastqc"]["cpu"]

    wrapper:
        "v2.0.0/bio/fastqc"