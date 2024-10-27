FROM ruby:3.3.5-bookworm

ENV WORKDIR=/rtetris
WORKDIR ${WORKDIR}
ADD . ${WORKDIR}

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-transport-https \
    vim \
    jq \
  && rm -rf /var/lib/apt/lists/*

ENV LC_ALL C.UTF-8

ENV PATH $WORKDIR/bin:$PATH

