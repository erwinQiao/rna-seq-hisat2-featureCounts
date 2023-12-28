samples = SMAPLES
rule merge and caculate FPKM:
    input:
        "results/featureCounts/{samples}.count"
    output:
        directory(mergeCounts = "results/mergeCounts")

    shell:
        