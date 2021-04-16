# Galaxy - Genome Annotation Suite
FROM quay.io/bgruening/galaxy:20.09
MAINTAINER Galaxy Genome Annotation <gga@galaxians.org>

WORKDIR /galaxy-central

# install-repository sometimes needs to be forced into updating the repo
ENV GALAXY_CONFIG_CONDA_AUTO_INSTALL=True \
	GALAXY_CONFIG_CONDA_AUTO_INIT=True \
	ENABLE_TTS_INSTALL=True \
	GALAXY_CONFIG_BRAND="Genome Annotation"

# Install required python packages before installing tools from toolshed
ADD postinst.sh /bin/postinst
RUN postinst

# Install tools
COPY genome_annotation_tools_1.yml $GALAXY_ROOT/tools_1.yaml
COPY genome_annotation_tools_2.yml $GALAXY_ROOT/tools_2.yaml
COPY genome_annotation_tools_3.yml $GALAXY_ROOT/tools_3.yaml
COPY tool_conf.xml /etc/config/gga_tool_conf.xml

# Split into multiple layers to minimize disk space usage while building
# Rules to follow:
#  - Keep in the same yaml file the tools that share common conda dependencies (conda is only able to use hardlinks within a Docker layer)
#  - Docker will use 2*(size of the layer) on the disk while building, so 1 yaml should not install more data than half of the remaining space on the disk
#     => 'big' tools should go in the first yaml file, the last yaml file should contain smaller tools
#  - When one of the layer can't be built with a "no space left" error message, you'll probably need to split a yaml in 2 (supposing you followed the previous rules)
RUN df -h && \
    install-tools $GALAXY_ROOT/tools_1.yaml -v && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    df -h

RUN df -h && \
    install-tools $GALAXY_ROOT/tools_2.yaml -v && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    df -h

RUN df -h && \
    install-tools $GALAXY_ROOT/tools_3.yaml -v && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    df -h

ENV GALAXY_CONFIG_TOOL_CONFIG_FILE config/tool_conf.xml.sample,config/shed_tool_conf.xml,/etc/config/gga_tool_conf.xml
# overwrite current welcome page
ADD welcome.html $GALAXY_CONFIG_DIR/web/welcome.html

RUN mkdir -p /apollo-data /jbrowse/data /tripal-data && \
    chmod 777 /apollo-data && \
    chmod 777 /jbrowse/data && \
    chmod 777 /tripal-data

# Mark folders as imported from the host.
VOLUME ["/export/", "/apollo-data/", "/jbrowse/data/", "/var/lib/docker", "/tripal-data/"]

ADD fix_perms.sh /bin/fix_perms
ADD fix_perms.conf /etc/supervisor/conf.d/apollo.conf

ENV GALAXY_WEBAPOLLO_URL="http://apollo:8080/apollo" \
    GALAXY_WEBAPOLLO_USER="admin@local.host" \
    GALAXY_WEBAPOLLO_PASSWORD=password \
    GALAXY_WEBAPOLLO_EXT_URL="/apollo" \
    GALAXY_SHARED_DIR="/apollo-data" \
    GALAXY_JBROWSE_SHARED_DIR="/jbrowse/data" \
    GALAXY_JBROWSE_SHARED_URL="/jbrowse" \
    GALAXY_TRIPAL_URL="http://tripal/tripal/" \
    GALAXY_TRIPAL_USER="admin" \
    GALAXY_TRIPAL_PASSWORD="changeme" \
    GALAXY_TRIPAL_SHARED_DIR="/tripal-data" \
    GALAXY_CHADO_DBHOST="chado" \
    GALAXY_CHADO_DBNAME="postgres" \
    GALAXY_CHADO_DBPASS="postgres" \
    GALAXY_CHADO_DBUSER="postgres" \
    GALAXY_CHADO_DBSCHEMA="public" \
    GALAXY_CHADO_DBPORT="5432" \
    ENABLE_FIX_PERMS=1
