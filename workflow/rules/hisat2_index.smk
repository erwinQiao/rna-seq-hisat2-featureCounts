samples = SAMPLES

if resources.genome == "homo_sapiens" and resources.build == 110:
    rule hisat2_ensembl_index:
        input:
            resources.ensembl_fasta
        output:
            expand("resources/hisat2_index_Homo_sapiens/Homo_sapiens_GRCh38_110.{i}.ht2",i =range(1,9))
        threads:
            config["resources"]["hisat2"]["cpu"]
        params:
            path = "resources/hisat2_index_Homo_sapiens/",
            prefix = "Homo_sapiens_GRCh38_110"
        conda:
            "../envs/hisat2.yaml"
        log:
            "logs/hisat2/index/Homo_sapiens_GRCh38_110.log"
        shell:
            """
            hisat2-build --quiet -p {threads} {input} {params.path}{params.prefix} 2> {log}
            """

elif resources.genome == "human" and resources.build == 44:
    rule hisat2_genecode_index:
        input:
            resources.gencode_fasta
        output:
            expand("resources/hisat2_index_human/human_GRCH38_p14.{i}.ht2",i = range(1,9))
        threads:
            config["resources"]["hisat2"]["cpu"]
        params:
            path = "resources/hisat2_index_Homo_sapiens/",
            prefix = "human_GRCH38_p14"

        conda:
            "../envs/hisat2.yaml"
        log:
            "logs/hisat2/index/human_GRCH38_p14.log"
        shell:
            """
            hisat2-build --quiet -p {threads} {input} {params.path}{params.prefix} 2> {log}
            """

