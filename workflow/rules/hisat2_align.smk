
samples = SAMPLES
if resources.genome == "homo_sapiens" and resources.build == 110:
    rule hisat2:
        input:
            reads = ["results/trimmed/{samples}_R1.fastq.gz", "results/trimmed/{samples}_R2.fastq.gz"],
            index = expand("resources/hisat2_index_Homo_sapiens/Homo_sapiens_GRCh38_110.i.ht2",i =range(1,8))
        output:
            "results/mapped/{samples}.bam"
        log:
            "logs/hisat2/align/{samples}.log"
        threads:
            config["resources"]["hisat2"]["cpu"]
        params:
            index = "resources/hisat2_index_Homo_sapiens/Homo_sapiens_GRCh38_110"
        conda:
            "../envs/hisat2.yaml"
        shell:
            "hisat2  --threads {threads} -x {params.index} -1 {input.reads[0]} -2 {input.reads[1]} | samtools view -Sbh -o {output}  2> {log}"

elif resources.genome == "human" and resources.build == 44:
    rule hisat2:
            input:
                reads = ["results/trimmed/{samples}_R1.fastq.gz", "results/trimmed/{samples}_R2.fastq.gz"],
                index = expand("resources/human_GRCH38_p14/human_GRCH38_p14.i.ht2",i =range(1,8))
            output:
                "results/mapped/{samples}.bam"
            log:
                "logs/hisat2/align/{samples}.log"
            threads:
                config["resources"]["hisat2"]["cpu"]
            params:
                index = "resources/hisat2_index_human/human_GRCH38_p14"
            conda:
                "../envs/hisat2.yaml"
            shell:
                "hisat2  --threads {threads} -x {params.index} -1 {input.reads[0]} -2 {input.reads[1]} | samtools view -Sbh -o {output} 2> {log}"