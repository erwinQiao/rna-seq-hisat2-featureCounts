samples = SAMPLES
rule featuresCounts:
    input:
        bam = "results/mapped/{samples}.bam",
        gtf = resources.ensembl_gtf

    threads:
        config["featureCounts"]["cpu"]

    output:
        count = "results/featureCounts/count/{samples}",
        log = "results/featuresCounts/log/{samples}"
    
    log:
        "logs/featureCounts/{sample}.log"
    script:
        "scripts/featureCounts.R 2>&1 {log}"
