###############################################################################################
# HCSS PAG2ADMG - BASE
###############################################################################################
FROM rocker/r-ubuntu:20.04 as hcss-pag2admg-base

RUN mkdir -p /srv/app
WORKDIR /srv/app

# update the image
RUN apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update
RUN apt-get upgrade -y
RUN apt-get install vim -y
RUN apt-get install net-tools -y
RUN apt-get install dos2unix -y

ENV R_HOME /usr/lib/R

RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:ubuntugis/ppa -y

# system libraries
RUN apt-get update && apt-get install -y \
  w3m \
  sudo \
  pandoc \
  pandoc-citeproc \
  libcurl4-gnutls-dev \
  libcairo2-dev \
  libxt-dev \
  libssl-dev \
  libssh2-1-dev \
  libssl1.1 \
  default-jdk \
  software-properties-common \
  libudunits2-dev \
  libgdal-dev \
  libgeos-dev \
  libproj-dev \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libssl-dev

RUN R -e "install.packages(c('devtools', \
  'roxygen2'), repos='https://cloud.r-project.org/')"

###############################################################################################
# HCSS PAG2ADMG - DEVELOPMENT
###############################################################################################
FROM hcss-pag2admg-base as hcss-pag2admg-dev

RUN mkdir -p /docker
COPY ./docker/entrypoint.sh /docker
RUN chmod +x /docker/entrypoint.sh
RUN dos2unix /docker/entrypoint.sh

ENTRYPOINT [ "/docker/entrypoint.sh" ]