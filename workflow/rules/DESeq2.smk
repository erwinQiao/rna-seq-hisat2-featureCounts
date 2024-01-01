rule DESeq2_init:
    input:
        counts = "results/mergeCounts/genesMerge.count"
    output:
        "results/DESeq2/all.rds",
        
    conda:
        "../envs/featureCounts.yaml"
    log:
        "logs/DESeq2/DESeq2_init.log"
    script:
        "../scripts/DESeq2_init.R"

rule DESeq2:
    input:

    output:

    conda:
        "../envs/featureCounts.yaml"
    log:
        "logs/DESeq2/DESeq2.log"
    script:
        "../scripts/DESeq2.R"

