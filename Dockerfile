# Galaxy - Genome Annotation Suite
#
# VERSION       0.1

FROM bgruening/galaxy-stable:dev

MAINTAINER Björn A. Grüning, bjoern.gruening@gmail.com

ENV GALAXY_CONFIG_BRAND Genome Annotation Suite

WORKDIR /galaxy-central

# Some basic packages
RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o iuc --name package_perl_5_18"

# Install NCBI SimilaritySearch
RUN install-repository \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name blast_datatypes" \
    "--url https://toolshed.g2.bx.psu.edu/ -o peterjc --name blastxml_to_top_descr --panel-section-name SimilaritySearch" \
    "--url https://toolshed.g2.bx.psu.edu/ -o peterjc --name blast_rbh --panel-section-name SimilaritySearch" \
    "--url https://toolshed.g2.bx.psu.edu/ -o iuc --name package_blast_plus_2_2_29" \
    "--url https://toolshed.g2.bx.psu.edu/ -o devteam --name ncbi_blast_plus --panel-section-name SimilaritySearch"

# The BLAST2GO database needs to be mounted in manually
RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name blast2go --panel-section-name SimilaritySearch" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name diamond --panel-section-name SimilaritySearch" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name data_manager_diamond_database_builder" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name interproscan5 --panel-section-name SimilaritySearch" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name augustus --panel-section-name GenePrediction" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name glimmer3 --panel-section-name GenePrediction"

RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name antismash --panel-section-name GeneCluster" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name crt --panel-section-name CRISPER" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name minced --panel-section-name CRISPER" \
    "--url http://toolshed.g2.bx.psu.edu/ -o jjohnson --name cdhit --panel-section-name SequenceClustering" \
    "--url http://toolshed.g2.bx.psu.edu/ -o clustalomega --name clustalomega --panel-section-name SequenceClustering" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name clustalw --panel-section-name SequenceClustering"

RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name clinod --panel-section-name Localisation" \
    "--url http://toolshed.g2.bx.psu.edu/ -o vipints --name nupop_0.1 --panel-section-name Localisation" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name twistdna --panel-section-name DNAStructure" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name repeat_masker --panel-section-name DNAStructure" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name effectivet3 --panel-section-name Classification" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name nlstradamus --panel-section-name Classification"

# FASTA tools
RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name fasta_compute_length --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o galaxyp --name fasta_merge_files_and_filter_unique_sequences --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name seq_filter_by_id --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name seq_rename --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name seq_select_by_id --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name get_orfs_or_cdss --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name fasta_formatter --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name fasta_nucleotide_changer --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name fasta_to_tabular --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name tabular_to_fasta --panel-section-name FASTATools" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name find_subsequences --panel-section-name FASTATools"

# Plotting
RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name package_weblogo_3_3" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name weblogo3 --panel-section-name Plotting" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name venn_list --panel-section-name Plotting" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name mummer --panel-section-name Plotting"

# Assembly tools
RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o lionelguy --name spades --panel-section-name Plotting" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name mira4_assembler --panel-section-name Plotting"

# EMBOSS
RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name package_emboss_5_0_0" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name emboss_5 --panel-section-name EMBOSS"


#package_bx_python_0_7

# Community workflows
RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name package_galaxy_ops_1_0_0" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name intersect --panel-section-id textutil" \
    "--url http://toolshed.g2.bx.psu.edu/ -o devteam --name column_maker --panel-section-id textutil" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name glimmer_gene_calling_workflow" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name find_genes_located_nearby_workflow" \
    "--url http://toolshed.g2.bx.psu.edu/ -o bgruening --name find_three_genes_located_nearby_workflow" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name secreted_protein_workflow" \
    "--url http://toolshed.g2.bx.psu.edu/ -o peterjc --name rxlr_venn_workflow"


# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
