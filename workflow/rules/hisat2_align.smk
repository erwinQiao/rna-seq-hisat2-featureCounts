samples = SAMPLES
if resources.genome == "homo_sapiens" and resources.build == 110:
    rule hisat2:
        input:
            reads = ["results/trimmed/{sample}_R1.fastq.gz", "results/trimmed/{sample}_R2.fastq.gz"],
            index = "resources/hisat2_index_Homo_sapiens_GRCh38_110/"
        output:
            "results/mapped/{sample}.bam"
        log:
            "logs/hisat2_align_{sample}.log"
        threads:
            config["resources"]["hisat2"]["cpu"]
        conda:
            "../envs/hisat2.yaml"
        shell:
            "hisat2  --threads {threads} -x {input.index}/index_Homo_sapiens_GRCh38_110 -1 {input.reads[0]} -2 {input.reads[1]} | samtools view -Sbh -o {output} 2> {log}"

elif resources.genome == "human" and resources.build == 44:
    rule hisat2:
            input:
                reads = ["results/trimmed/{sample}_R1.fastq.gz", "results/trimmed/{sample}_R2.fastq.gz"],
                index = "resources/hisat2_index_human_GRCH38_p14/"
            output:
                "results/mapped/{sample}.bam"
            log:
                "logs/hisat2_align_{sample}.log"
            threads:
                config["resources"]["hisat2"]["cpu"]
            conda:
                "../envs/hisat2.yaml"
            shell:
                "hisat2  --threads {threads} -x {input.index}/index_human_GRCH38_p14 -1 {input.reads[0]} -2 {input.reads[1]} | samtools view -Sbh -o {output} 2> {log}"