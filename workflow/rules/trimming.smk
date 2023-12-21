rule trim_galore_pe:
    input:
        [,]
    output:
        fastq_fwd=
        report_fwd=
        fastq_rev=
        report_rev=
    threads:

    params:
        extra=
    log:
        "log/trim_galore/{sample}.log"
    conda:
        "/envs/"