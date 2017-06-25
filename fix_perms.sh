#!/bin/bash
while [[ $ENABLE_FIX_PERMS == "1" ]]; do
    chmod 777 -R /apollo-data/
    chmod 777 -R /tripal-data/
    chmod 777 -R /jbrowse/data/
    sleep 60;
done;
