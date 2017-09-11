#!/bin/bash

# Make sure at least the shared folders are writable by galaxy user
chmod 777 /apollo-data/
chmod 777 /tripal-data/
chmod 777 /jbrowse/data/

# Check permissions recursively and regularly if asked
while [[ $ENABLE_FIX_PERMS == "1" ]]; do
    chmod 777 -R /apollo-data/
    chmod 777 -R /tripal-data/
    chmod 777 -R /jbrowse/data/
    sleep 60;
done;
