samples = SAMPLES,
end = ["_R1","_R2"]

rule fastqc:
    input:
        "reads/{samples}{end}.fastq.gz"

    output:
        html="results/qc/fastqc/{sample}{end}.html"
        zip="results/qc/fastqc/{sample}{end}_fastqc.zip" 

    params:
        extra = "--quiet"

    threads: config["resources"]["fastqc"]["cpu"]

    log:
        "logs/fastqc/{sample}{end}.log"

    threads:config["resources"]["fastqc"]["cpu"]

    shell:
        "fastqc -f fastqc {params.extra} -t {threads} -o results/qc {input}",
        "mv *.html {output.html}",
        "mv *.fastq.gz {output.zip}"



        