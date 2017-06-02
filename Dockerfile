# Galaxy - Genome Annotation Suite

FROM bgruening/galaxy-sequence-tools:17.05

MAINTAINER Björn A. Grüning, bjoern.gruening@gmail.com

ENV GALAXY_CONFIG_BRAND "Genome Annotation"

# Install tools
COPY genome_annotation_tools.yml $GALAXY_ROOT/tools.yaml

RUN install-tools $GALAXY_ROOT/tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs

