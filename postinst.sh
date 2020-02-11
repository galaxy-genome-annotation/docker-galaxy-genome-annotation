#!/bin/bash

. $GALAXY_VIRTUAL_ENV/bin/activate
pip install bcbio-gff "biopython==1.74" tripal chado
