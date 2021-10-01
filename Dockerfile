# syntax=docker/dockerfile:1
FROM ubuntu:latest
WORKDIR /usr/src/app


RUN apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt-get install -y tzdata

RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN ln -s /usr/bin/python3 /usr/bin/python

#intall an bunch o deps
RUN apt-get install raxml
RUN apt-get install seqtk
RUN apt-get install bcftools -y
RUN apt-get install samtools -y
RUN apt-get install git -y

#fastx toolkit and bwa-mem need wget to be installed
RUN apt-get install wget -y
RUN wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
RUN tar -xjf fastx_toolkit_0.0.13_binaries_Linux_2.6_amd64.tar.bz2
RUN cp ./bin/* /usr/local/bin
ENV PATH="/usr/src/app/bin:${PATH}"

RUN wget https://github.com/bwa-mem2/bwa-mem2/releases/download/v2.0pre2/bwa-mem2-2.0pre2_x64-linux.tar.bz2
RUN tar -xjf bwa-mem2-2.0pre2_x64-linux.tar.bz2
RUN cp bwa-mem2-2.0pre2_x64-linux/bwa-mem2 /usr/local/bin/
RUN PATH="/usr/src/app/bwa-mem2-2.0pre2_x64-linux:${PATH}"

#########
## What should happen next? ##

# install Extensiphy
RUN git clone https://github.com/McTavishLab/extensiphy.git


# Try to run Extensiphy to see whats been added to the path
# Add programs to path that werent added

