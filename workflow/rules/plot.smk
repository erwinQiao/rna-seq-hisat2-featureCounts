rule pca:
    input:
        TPM = "results/mergeCounts/genesTPM.count"
    output:
        "results/plot/PCAplot.pdf"
    conda:
        "../envs/featureCounts.yaml"
    log:
        "logs/plot/pca.log"
    script:
        "../scripts/PCA.R"

rule boxplot:
    input:
        fpkm = "results/mergeCounts/genesFPKM.count"
    output:
        "results/plot/ViolinplotFPKM.pdf"
    conda:
        "../envs/featureCounts.yaml"
    log:
        "logs/plot/boxplot.log"
    script:
        "../scripts/boxplot.R"

