# BASE CONTAINER TO COMPILE SciDB
#
# VERSION 1.0
#
#
#
#
#
#PORT MAPPING
#SERVICE DEFAULT MAPPED
#ssh 			22 22
#Postgresql 	5432 5432
#SciDB 			1239 1239


FROM ubuntu:15.10
MAINTAINER Dmitry Karpeyev


# install
RUN apt-get -qq update && apt-get install --fix-missing -y --force-yes \
	openssh-server \
	openssh-client \
	sudo \
	wget \
	gcc \
	libc-dev-bin \
	libc6-dev \
	libgomp1 \
	libssl-dev \
	linux-libc-dev \
	zlib1g-dev \
	postgresql-9.4 \
	dialog \
	curl \
	libcurl3-dev \
	sshpass \ 
	subversion \ 
	expect \ 
	git

	
# Set environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN env
	
	
# Configure users
RUN useradd --home /home/scidb --create-home --uid 1001 --group sudo --shell /bin/bash scidb
RUN usermod -a -G sudo scidb
RUN echo 'root:xxxx.xxxx.xxxx' | chpasswd
RUN echo 'postgres:xxxx.xxxx.xxxx' | chpasswd
RUN echo 'scidb:xxxx.xxxx.xxxx' | chpasswd
RUN mkdir /home/scidb/data
RUN chown scidb:scidb /home/scidb/data

	
# setup
COPY scidb.tar.gz /home/scidb 
RUN tar zxf scidb.tar.gz -C /home/scidb/scidb-dev
RUN chown -R scidb:scidb /home/scidb/scidb-dev

	
# Configure SSH
RUN mkdir /var/run/sshd
RUN echo 'StrictHostKeyChecking no' >> /etc/ssh/ssh_config


# Configure Postgres
RUN echo 'host all all 255.255.0.0/16 md5' >> /etc/postgresql/9.4/main/pg_hba.conf

	
# Restarting services
RUN stop ssh
RUN start ssh


EXPOSE 22
EXPOSE 1239
EXPOSE 5432


CMD    ["/usr/sbin/sshd", "-D"]
