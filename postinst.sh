#!/bin/bash

. $GALAXY_VIRTUALENV/bin/activate
pip install bcbio-gff biopython
sed -i 's|#filter-with = proxy-prefix|filter-with = proxy-prefix|g;s|#cookie_path = None|cookie_path = /galaxy|g;' /etc/galaxy/galaxy.ini
