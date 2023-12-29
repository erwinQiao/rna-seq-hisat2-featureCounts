rule mergeCounts:
    input:
        expand("results/featureCounts/{samples}.count",samples=SAMPLES)
    output:
        counts = "results/mergeCounts/genesMerge.count",
        FPKM = "results/mergeCounts/genesFPKM.count",
        TPM = "results/mergeCounts/genesTPM.count"
    conda:
        "../envs/featureCounts.yaml"
    script:
        "../scripts/mergeCounts.R"
        