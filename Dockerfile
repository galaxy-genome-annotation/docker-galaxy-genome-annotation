FROM bgruening/galaxy-stable
MAINTAINER Eric Rasche <esr@tamu.edu>

ENV GALAXY_CONFIG_BRAND=Apollo \
    GALAXY_LOGGING=full

WORKDIR /galaxy-central


RUN install-repository \
    "--url http://toolshed.g2.bx.psu.edu/     -o iuc         --name jbrowse --panel-section-id Apollo"


RUN git clone https://github.com/TAMU-CPT/galaxy-webapollo tools/apollo
ADD tool_conf.xml /etc/config/apollo_tool_conf.xml
ENV GALAXY_CONFIG_TOOL_CONFIG_FILE /galaxy-central/config/tool_conf.xml.sample,/etc/config/apollo_tool_conf.xml

# Mark folders as imported from the host.
VOLUME ["/export/", "/data/", "/var/lib/docker"]

EXPOSE :80

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]
