samples = SAMPLES
rule featuresCounts:
    input:
        bam = "results/mapped/{samples}.bam",
        gtf = resources.ensembl_gtf
    threads:
        config["resources"]["featureCounts"]["cpu"]
    output:
        count_output = "results/featureCounts/count/{samples}.count",
        logfile = "results/featureCounts/log/{samples}.log"
    conda:
        "../envs/featureCounts.yaml"
    log:
        "logs/featureCounts/{samples}.log"
    script:
        "scripts/featureCounts.R 2>&1 {log}"
