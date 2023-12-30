rule boxplot:
    input:
        fpkm = "results/mergeCounts/genesFPKM.count"
    output:
        "results/plot/ViolinplotFPKM.pdf"
    params:
        outputpath = "results/plot"
    conda:
        "../envs/featureCounts.yaml"
    log:
        "logs/plot/boxplot.log"
    script:
        "../scripts/boxplot.R"

