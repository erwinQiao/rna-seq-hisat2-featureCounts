import os 

class Resources:
    """Gets URLs and file name of fasta and git files based a provieded genome and build
    """
    # create genome directory
    os.makedirs("resources/", exist_ok=True)

    def __init__(self, genome,build):
        self.genome = genome
        self.build = build

        # base URL
        base_url_ensembl = "https://ftp.ensembl.org/pub/release-"
        base_url_gencode = "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_"

        if genome.lower() == "human" and build == 44:
            # download genecode files 
            self.gencode_fa_url = f"{base_url_gencode}human/release_{build}/GRCh38.p14.genome.fa.gz"
            self.gencode_trx_fa_url = f"{base_url_gencode}human/release_{build}/gencode.v{build}.transcripts.fa.gz"
            self.gencode_gtf_url = f"{base_url_gencode}human/release_{build}/gencode.v{build}.annotation.gtf.gz"

            # set sha256sums for unzipped genome files
            self.gencode_fa_sha256 = "3ed0c28ded22eac00112e47331c3e146f5c0a50b9dbe2d15dac818ce2a8103df"
            self.gencode_trx_fa_sha256 = "103e0632a36c839a2e5717040c1a4fdb259c3b8a57d4e664335717e02507c4f0"
            self.gencode_gtf_sha256 = "46fc6e733fc73b236ffa68b770c5ee0cedd998797107cb4691bd8ca5c104df16"

            #download unzip file names
            self.gencode_fasta = self._file_from_url(self.gencode_fa_url)
            self.gencode_trx_fasta = self._file_from_url(self.gencode_trx_fa_url)
            self.gencode_gtf = self._file_from_url(self.gencode_gtf_url)

        elif genome.lower() == "homo_sapiens" and build == 110:
            # download ensembl files
            self.ensembl_fa_url = f"{base_url_ensembl}{build}/fasta/{genome}/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz"
            self.ensembl_gtf_url = f"{base_url_ensembl}{build}/{genome}/Homo_sapiens.GRCh38.110.chr.gtf.gz"

            # download unzip file names
            self.ensembl_fasta = self._file_from_url(self.ensembl_fa_url)
            self.ensembl_gtf = self._file_from_url(self.ensembl_gtf_url)


    
    def _file_from_url(self, url):
        """Return file path for unzipped downloaded file
        """
        return f"resources/{os.path.basename(url).replace('.gz','')}"
    
