samples = SAMPLES
if resources.genome == "homo_sapiens" and resources.build == 110:
    rule hisat2_ensembl_index:
        input:
            "resources.ensembl_fasta"
        output:
            directory("resources/hisat2_index_Homo_sapiens_GRCh38_110")
        threads: 
            config["resources"]["hisat2"]["cpu"]
        params:
            prefix = "index_Homo_sapiens_GRCh38_110"
        conda:
            "../envs/hisat2.yaml"
        log:
            "logs/hisat2/index/Homo_sapiens_GRCh38_110.log"
        shell:
            "hisat2-build -p {threads} {input} {params.prefix} 2> {log}"
    
    rule hisat2:
        input:
            reads = ["results/trimmed/{sample}_R1.fastq.gz", "results/trimmed/{sample}_R2.fastq.gz"],
            index = "resources/hisat2_index_Homo_sapiens_GRCh38_110/index_Homo_sapiens_GRCh38_110"
        output:
            "results/mapped/{sample}.bam"
        log:
            "logs/hisat2_align_{sample}.log"
        threads:
            config["resources"]["hisat2"]["cpu"]
        conda:
            "../envs/hisat2.yaml"
        shell:
            "hisat2  --threads {threads} -x {input.index} -1 {input[0]} -2 {input[1]} "



elif resources.genome == "human" and resources.build == 44:
    rule hisat2_genecode_index:
        input:
            "resources.gencode_fasta"
        output:
            directory("resources/hisat2_index_human_GRCH38_p14")
        threads: 
            config["resources"]["hisat2"]["cpu"]
        params:
            prefix = "index_human_GRCH38_p14"

        conda:
            "../envs/hisat2.yaml"
        log:
            "logs/hisat2/index/human_GRCH38_p14.log"
        shell:
            "hisat2-build -p {threads} {input} {params.prefix} 2> {log}" 