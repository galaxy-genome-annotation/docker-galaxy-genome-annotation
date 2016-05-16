#!/bin/bash

. $GALAXY_VIRTUALENV/bin/activate
pip install bcbio-gff biopython
sed -i 's|/opt/apollo/data/galaxy/|/apollo-data/|g' tools/apollo/*.xml
mkdir /apollo-data/ && chmod 777 /apollo-data/
