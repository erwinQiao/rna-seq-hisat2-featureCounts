samples = SAMPLES
rule featuresCounts:
    input:
        bam = "results/mapped/{samples}.bam",
        gtf = resources.ensembl_gtf
    output:
        count_output = "results/featureCounts/{samples}",
    conda:
        "../envs/featureCounts.yaml"
    log:
        "logs/featureCounts/{samples}.log"
    script:
        "../scripts/featureCounts.R "
