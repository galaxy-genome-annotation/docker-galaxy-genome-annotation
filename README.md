**NB:** This image will be merged with the other one in this repository in the future. This image was created to demonstrate Apollo integration.

Galaxy Image for Annotation
===========================

```
docker pull quay.io/erasche/docker-galaxy-annotation
```

A complete and production ready Galaxy instance with installed BLAST+ tools.

 * [Installed tools](#installed-tools)
 * [Users & Passwords](#user--passowrds)
 * [Reproducibility of your search results](#reproducibility-of-your-search-results)
 * [Using large external BLAST databases](#using-large-external-blast-databases)
 * [Requirements](#requirements)
 * [Restarting Galaxy](#restarting-galaxy)
 * [History](#history)
 * [Support & Bug Reports](#support--bug-reports)
 * [Licence (MIT)](#license-mit)


Installed tools
===============

 * [JBrowse-in-Galaxy](https://github.com/galaxyproject/tools-iuc/tree/master/tools/jbrowse)
 * [Apollo Webservices](https://github.com/TAMU-CPT/galaxy-webapollo)
 * [Other specific tools](https://github.com/galaxy-genome-annotation/galaxy-tools)

Environment variables
=====================

The following environment variables must be set:

ENV                           | Use
---                           | ---
 `$GALAXY_WEBAPOLLO_URL`      | The URL at which Apollo is accessible, internal to Galaxy and where the tools run. Must be absolute, with FQDN and protocol. (default: http://apollo:8080/apollo)
 `$GALAXY_WEBAPOLLO_USER`     | The admin user which Galaxy should use to talk to Apollo. (default: admin@local.host)
 `$GALAXY_WEBAPOLLO_PASSWORD` | The password for the admin user. (default: password)
 `$GALAXY_WEBAPOLLO_EXT_URL`  | The external URL at which Apollo is accessible to end users. May be relative or absolute. (default: /apollo)
 `$GALAXY_SHARED_DIR`         | Directory shared between Galaxy and Apollo, used to exchange JBrowse instances. (default: /apollo-data)
 `$GALAXY_JBROWSE_SHARED_DIR` | Directory shared between Galaxy and JBrowse, used to exchange JBrowse datasets. (default: /jbrowse/data)
 `$GALAXY_JBROWSE_SHARED_URL` | The external URL at which JBrowse is accessible to end users. May be relative or absolute. (default: /jbrowse)

Users & Passwords
================

The Galaxy Admin User has the username ``admin@galaxy.org`` and the password ``admin``.
The PostgreSQL username is ``galaxy``, the password is ``galaxy`` and the database name is ``galaxy`` (I know I was really creative ;)).
If you want to create new users, please make sure to use the ``/export/`` volume. Otherwise your user will be removed after your docker session is finished.


Requirements
============

- [docker](https://docs.docker.com/installation/)


Restarting Galaxy
=================

If you want to restart Galaxy without restarting the entire Galaxy container we can use `docker exec` (docker > 1.3).

```docker exec <container name> supervisorctl restart galaxy:```


History
=======

 - 0.1: Initial release!


Support & Bug Reports
=====================

For support, questions, or feature requests, please fill bug reports at https://github.com/erasche/docker-galaxy-annotation/issues.


Licence (MIT)
=============

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
