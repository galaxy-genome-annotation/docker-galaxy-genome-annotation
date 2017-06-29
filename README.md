[![Build Status](https://travis-ci.org/galaxy-genome-annotation/docker-galaxy-genome-annotation.svg?branch=master)](https://travis-ci.org/galaxy-genome-annotation/docker-galaxy-genome-annotation)
[![Docker Repository on Quay](https://quay.io/repository/galaxy/genome-annotation/status "Docker Repository on Quay")](https://quay.io/repository/galaxy/genome-annotation)

# Galaxy Image for Genome Annotation

```
docker pull quay.io/galaxy/genome-annotation
```

For running the complete GMOD stack (including Apollo, Tripal, Chado), please see [our other repository](https://github.com/galaxy-genome-annotation/dockerized-gmod-deployment)

A complete and production ready Galaxy instance for Genome Annotation.

 * [Installed tools](#installed-tools)
 * [Usage](#usage)
 * [Users & Passwords](#user--passowrds)
 * [Reproducibility of your search results](#reproducibility-of-your-search-results)
 * [Using large external BLAST databases](#using-large-external-blast-databases)
 * [Requirements](#requirements)
 * [Restarting Galaxy](#restarting-galaxy)
 * [History](#history)
 * [Support & Bug Reports](#support--bug-reports)
 * [Licence (MIT)](#license-mit)


## Installed tools

* Assembly
	* Spades, Mira
* Structural Prediction
	* Glimmer
	* Augustus
* Functional Prediction
	* [BLAST+](http://blast.ncbi.nlm.nih.gov)
	* InterProScan
	* BLAST, Diamond, Blast2GO
* Utilities
	* FASTA manipulation tools
	* EMBOSS
* Comparative Genomics
	* CD-Hit, ClustalW
	* AntiSmash
	* mummer
* Annotation / Visualization
	* [Apollo Tools](https://github.com/galaxy-genome-annotation/galaxy-tools/tree/master/tools/apollo)
	* [JBrowse-in-Galaxy](https://github.com/galaxyproject/tools-iuc/tree/master/tools/jbrowse)
	* [JBrowse-in-Galaxy Extras](https://github.com/galaxy-genome-annotation/galaxy-tools/tree/master/tools/jbrowse)
	* [Tripal Admin](https://github.com/galaxy-genome-annotation/galaxy-tools/tree/master/tools/tripal)
	* Circos
* Automatic annotation
    * Prokka

## Usage

You must have [docker installed](https://docs.docker.com/installation/). Once that is available, it is as simple as:

```bash
docker run -d -p 8080:80 galaxy/genome-annotation
```

Please consult the  [docker manual](http://docs.docker.io/) for detailed
explanations of available parameters. Please see
[bgruening/docker-galaxy-stable](https://github.com/bgruening/docker-galaxy-stable)
for more information on how to run this image.

Environment variables
=====================

The following environment variables must be set:

ENV                           | Use
----------------------------- | --------------------------------
 `$GALAXY_WEBAPOLLO_URL`      | The URL at which Apollo is accessible, internal to Galaxy and where the tools run. Must be absolute, with FQDN and protocol. (default: http://apollo:8080/apollo)
 `$GALAXY_WEBAPOLLO_USER`     | The admin user which Galaxy should use to talk to Apollo. (default: admin@local.host)
 `$GALAXY_WEBAPOLLO_PASSWORD` | The password for the admin user. (default: password)
 `$GALAXY_WEBAPOLLO_EXT_URL`  | The external URL at which Apollo is accessible to end users. May be relative or absolute. (default: /apollo)
 `$GALAXY_SHARED_DIR`         | Directory shared between Galaxy and Apollo, used to exchange JBrowse instances. (default: /apollo-data)
 `$GALAXY_JBROWSE_SHARED_DIR` | Directory shared between Galaxy and JBrowse, used to exchange JBrowse datasets. (default: /jbrowse/data)
 `$GALAXY_JBROWSE_SHARED_URL` | The external URL at which JBrowse is accessible to end users. May be relative or absolute. (default: /jbrowse)
 `$GALAXY_TRIPAL_URL`         | The URL at which Tripal is accessible, internal to Galaxy and where the tools run. Must be absolute, with FQDN and protocol. (default: http://tripal/tripal/)
 `$GALAXY_TRIPAL_USER`        | The admin user which Galaxy should use to talk to Tripal. (default: admin)
 `$GALAXY_TRIPAL_PASSWORD`    | The password for the tripal admin user. (default: changeme)
 `$GALAXY_TRIPAL_SHARED_DIR`  | Directory shared between Galaxy and Tripal, used to exchange Tripal datasets. (default: /tripal-data)
 `$ENABLE_FIX_PERMS`          | Set this to 1 to let the container ensure that $GALAXY_SHARED_DIR, $GALAXY_JBROWSE_SHARED_DIR and $GALAXY_TRIPAL_SHARED_DIR are constantly world writable (chmod -R 777) (default: 1)

## Users & Passwords

The Galaxy Admin User has the username ``admin@galaxy.org`` and the password
``admin``. If you want to create new users, please make sure to use the ``/export/`` volume, otherwise all data will be removed whenever the container is restarted.


## Reproducibility of Your Search Results

BLAST databases are updated daily and are not versioned. This is a general
problem for reproducibility of search results. In Galaxy we track the program
version, all settings and the input files. The underlying database can be
tracked but this is usually very storage expensive. Note that the large NCBI
BLAST databases exceeds 100 GB in size. To enable 100% reproducibility you can
simply create your own BLAST datbase with Galaxy. Download your database as
FASTA file and use the tool `NCBI BLAST+ makeblastdb` to convert your FASTA
file to a proper BLAST database. These steps are reproducibly, with all
settings and inputs.

If you want to use the precalculated BLAST databases from the [NCBI FTP
server](ftp://ftp.ncbi.nlm.nih.gov/blast/db/) you can configure your BLAST
Galaxy instance to use those. Please have a look at [Using large external BLAST
databases](#large_databases). We have plans to make this a lot simples by using
Galaxy *data managers*. You can track to progess here:
https://github.com/peterjc/galaxy_blast/issues/22

Please understand that we cannot ship the NCBI BLAST databases by default in
this Docker container, as we try to keep the image as small as possible.


## Using Large External BLAST Databases

You can get BLAST databases directly from the [NCBI
server](ftp://ftp.ncbi.nlm.nih.gov/blast/db/) and include them into your Galaxy
docker container.

 - Download your databases from [ftp://ftp.ncbi.nlm.nih.gov/blast/db/](ftp://ftp.ncbi.nlm.nih.gov/blast/db/).
   You can use the NCBI suggested [perl script](http://www.ncbi.nlm.nih.gov/blast/docs/update_blastdb.pl) to automatize this step.
 - Store all your BLAST databases in one directory, for example `/galaxy_store/data/blast_databases/`
 - Start your Galaxy container with `-v /galaxy_store/data/blast_databases/:/data/` to have access your databases inside of your container
 - Start your Galaxy container with ``-v /home/user/galaxy_storage/:/export/`` to export all config files to your host operating system
 - Modify your `blast*.loc` files under `/home/user/galaxy_storage/galaxy-central/tool-data/blast*.loc` on your host, or under `/export/galaxy-central/tool-data/blast*.loc` from within your container.
 - You need to add the paths to your blast databases. They need to look like `/export/swissprot/swissprot`
 - Restart your Galaxy instance, for example with ```docker exec <container name> supervisorctl restart galaxy:```

From now on you should see predifined BLAST databases in your Galaxy User Interface if you choose `Locally installed BLAST database`.



## Restarting Galaxy

If you want to restart Galaxy without restarting the entire Galaxy container we can use `docker exec` (docker > 1.3).

```docker exec <container name> supervisorctl restart galaxy:```


## History

- 0.2: Merge with the now-deprecated erasche version of this image.
- 0.1: Initial release!


## Support & Bug Reports

For support, questions, or feature requests, please [file bug reports on our github](https://github.com/galaxy-genome-annotation/docker-galaxy-genome-annotation/issues).


## Licence (MIT)

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
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


## Support

This material is based upon work supported by the National Science Foundation under Grant Number (Award 1565146)
