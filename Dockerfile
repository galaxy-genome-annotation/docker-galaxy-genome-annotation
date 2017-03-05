FROM bgruening/galaxy-stable:17.01
MAINTAINER Eric Rasche <esr@tamu.edu>

WORKDIR /galaxy-central

# install-repository sometimes needs to be forced into updating the repo
ENV GALAXY_CONFIG_CONDA_AUTO_INSTALL=True \
	GALAXY_CONFIG_CONDA_AUTO_INIT=True \
	GALAXY_CONFIG_USE_CACHED_DEPENDENCY_MANAGER=True \
	ENABLE_TTS_INSTALL=True \
	GALAXY_CONFIG_BRAND=GMOD

ADD tools.yml $GALAXY_ROOT/tools.yaml
RUN install-tools $GALAXY_ROOT/tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs


ADD tool_conf.xml /etc/config/apollo_tool_conf.xml
ENV GALAXY_CONFIG_TOOL_CONFIG_FILE /galaxy-central/config/tool_conf.xml.sample,/galaxy-central/config/shed_tool_conf.xml,/etc/config/apollo_tool_conf.xml
# overwrite current welcome page
ADD welcome.html $GALAXY_CONFIG_DIR/web/welcome.html

# Mark folders as imported from the host.
VOLUME ["/export/", "/apollo-data/", "/jbrowse/data/", "/var/lib/docker"]

ADD postinst.sh /bin/postinst
RUN postinst && \
    chmod 777 /apollo-data && \
    chmod 777 /jbrowse/data

RUN git clone https://github.com/TAMU-CPT/galaxy-apollo tools/apollo && \
    cd tools/apollo && \
    git checkout 001673c59a82063c4f8cf1cbfa19f81fd3cfe16b

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
    GALAXY_JBROWSE_SHARED_URL="/jbrowse"
