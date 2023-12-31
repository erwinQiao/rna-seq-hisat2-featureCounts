if resources.genome == "human" and resources.build == 44:
    rule get_gencode_genome_fasta:
        output:
            ensure(resources.gencode_fasta, sha256= resources.gencode_fa_sha256)
        retries: 3
        params:
            url = resources.gencode_fa_url
        log:
            "logs/resources/get_genecode.fasta.log"
        conda:
            "../envs/resources.yaml"
        
        shell:
            "wget -c -q {params.url} -O {output}.gz && gunzip -f {output}.gz 2> {log}" 

    rule get_gencode_transcritome_fasta:
        output:
            ensure(resources.gencode_trx_fasta, sha256= resources.gencode_trx_fa_sha256)
        retries: 3
        params:
            url= resources.gencode_trx_fa_url 
        
        log:
            "logs/resources/get_transcriptome_fasta.log"
        conda:
            "../envs/resources.yaml"
        shell:
            "wget -c -q {params.url} -O {output}.gz && gunzip -f {output}.gz 2> {log}" 
        
    rule get_gencode_gtf:
        output:
            ensure(resources.gencode_gtf, sha256= resources.gencode_gtf_sha256)
        retries: 3
        params:
            url = resources.gencode_gtf_url
        log:
            "logs/resources/get_gencode_gtf.log"
        conda:
            "../envs/resources.yaml"
        shell:
            "wget -c -q {params.url} -O {output}.gz && gunzip -f {output}.gz 2> {log}" 

elif resources.genome == "homo_sapiens" and resources.build == 110:
    rule get_ensembl_genome_fasta:
        output:
            resources.ensembl_fasta
        retries: 3
        params:
            url= resources.ensembl_fa_url
        log:
            "logs/resources/get_ensembl_genome_fasta.log"
        conda:
            "../envs/resources.yaml"
        shell:
            "wget -c -q {params.url} -O {output}.gz && gunzip -f {output}.gz 2> {log}" 

    rule get_ensembl_gtf:
        output:
            resources.ensembl_gtf
        retries: 3
        params:
            url = resources.ensembl_gtf_url
        log:
            "logs/resources/get_ensembl_gtf.log"
        conda:
            "../envs/resources.yaml"
        shell:
            "wget -c -q {params.url} -O {output}.gz && gunzip -f {output}.gz 2> {log}" 
