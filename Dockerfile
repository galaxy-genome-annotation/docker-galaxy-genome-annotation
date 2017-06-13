# Galaxy - Genome Annotation Suite
FROM bgruening/galaxy-sequence-tools:17.05
MAINTAINER Galaxy Genome Annotation <gga@galaxians.org>

WORKDIR /galaxy-central

# install-repository sometimes needs to be forced into updating the repo
ENV GALAXY_CONFIG_CONDA_AUTO_INSTALL=True \
	GALAXY_CONFIG_CONDA_AUTO_INIT=True \
	GALAXY_CONFIG_USE_CACHED_DEPENDENCY_MANAGER=True \
	ENABLE_TTS_INSTALL=True \
	GALAXY_CONFIG_BRAND="Genome Annotation"

# Install tools
COPY genome_annotation_tools.yml $GALAXY_ROOT/tools.yaml

RUN install-tools $GALAXY_ROOT/tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs


ADD tool_conf.xml /etc/config/apollo_tool_conf.xml
ENV GALAXY_CONFIG_TOOL_CONFIG_FILE /galaxy-central/config/tool_conf.xml.sample,/galaxy-central/config/shed_tool_conf.xml,/etc/config/apollo_tool_conf.xml
# overwrite current welcome page
ADD welcome.html $GALAXY_CONFIG_DIR/web/welcome.html

# Mark folders as imported from the host.
VOLUME ["/export/", "/apollo-data/", "/jbrowse/data/", "/var/lib/docker", "/tripal-data/"]

ADD postinst.sh /bin/postinst
RUN postinst && \
    chmod 777 /apollo-data && \
    chmod 777 /jbrowse/data && \
    chmod 777 /tripal-data

RUN git clone https://github.com/galaxy-genome-annotation/galaxy-tools /tmp/galaxy-tools/ && \
    cp -RT /tmp/galaxy-tools/tools/ tools/ && \
    rm -rf /tmp/galaxy-tools/

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
    GALAXY_TRIPAL_SHARED_DIR="/tripal-data"
