FROM bgruening/galaxy-stable
MAINTAINER Eric Rasche <esr@tamu.edu>

ENV GALAXY_CONFIG_BRAND=Apollo \
    GALAXY_LOGGING=full

WORKDIR /galaxy-central


RUN install-repository "--url https://toolshed.g2.bx.psu.edu/ -o iuc --name jbrowse --panel-section-name JBrowse"

ADD tool_conf.xml /etc/config/apollo_tool_conf.xml
ENV GALAXY_CONFIG_TOOL_CONFIG_FILE /galaxy-central/config/tool_conf.xml.sample,/galaxy-central/config/shed_tool_conf.xml,/etc/config/apollo_tool_conf.xml
# overwrite current welcome page
ADD welcome.html $GALAXY_CONFIG_DIR/web/welcome.html

# Mark folders as imported from the host.
VOLUME ["/export/", "/apollo-data/", "/var/lib/docker"]

ADD postinst.sh /bin/postinst
RUN postinst && \
    chmod 777 /apollo-data

RUN git clone https://github.com/TAMU-CPT/galaxy-webapollo tools/apollo && \
    cd tools/apollo && \
    git checkout 434f182c2d6d4e96b213214abf3e58787657ae4a

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
