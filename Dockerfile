#
# See the top level Makefile in https://github.com/docker/docker for usage.
#
FROM debian:jessie
MAINTAINER Mary Anthony <mary@docker.com> (@moxiegirl)

WORKDIR /src
EXPOSE 8000

RUN apt-get update \
	&& apt-get install -y \
		gettext \
		git \
		libssl-dev \
		make \
		python-dev \
		python-pip \
		python-setuptools \
		vim-tiny \
		s3cmd \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Required to publish the documentation.
# The 1.4.4 version works: the current versions fail in different ways
# TODO: Test to see if the above holds true
RUN pip install awscli==1.4.4 pyopenssl==0.12

ENV HUGO_VERSION 0.13
RUN curl -sSL https://github.com/spf13/hugo/releases/download/v{HUGO_VERSION}/hugo_${HUGO_VERSION}_linux_amd64.tar.gz \
	| tar -v -C /usr/local/bin -xz --strip-components 1 \
	&& mv /usr/local/bin/hugo_${HUGO_VERSION}_linux_amd64 /usr/local/bin/hugo

COPY requirements.txt /src/
RUN pip install -r requirements.txt

COPY . /src/
