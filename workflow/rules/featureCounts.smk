samples = SAMPLES
if resources.genome =="homo_sapiens" and resources.build==110:
    rule featuresCounts:
        input:
            bam = "results/mapped/{samples}.bam",
            gtf = resources.ensembl_gtf
        output:
            count_output = "results/featureCounts/{samples}.count",
        params:
            outdir = "results/featureCounts/{samples}",
        conda:
            "../envs/featureCounts.yaml"
        log:
            "logs/featureCounts/{samples}.log"
        script:
            "../scripts/featureCounts.R"
elif resources.genome =="human" and resources.build==44:
    rule featuresCounts:
        input:
            bam = "results/mapped/{samples}.bam",
            gtf = resources.gencode_gtf
        output:
            count_output = "results/featureCounts/{samples}.count",
        params:
            outdir = "results/featureCounts/{samples}",
        conda:
            "../envs/featureCounts.yaml"
        log:
            "logs/featureCounts/{samples}.log"
        script:
            "../scripts/featureCounts.R"

