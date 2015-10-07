# Bro Sandbox - Bro 2.4.1
#
# VERSION               1.0
FROM      debian
MAINTAINER Jon Schipp <jonschipp@gmail.com>

# Metadata
LABEL program=bro

# Specify container username e.g. training, demo
ENV VIRTUSER bro
# Specify program
ENV PROG bro
# Specify source extension
ENV EXT tar.gz
# Specify Bro version to download and install (e.g. bro-2.3.1, bro-2.4)
ENV VERS 2.4.1
# Install directory
ENV PREFIX /opt/bro
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bro/bin

# Install dependencies
RUN apt-get update -qq
RUN apt-get install -yq build-essential cmake make gcc g++ flex bison libpcap-dev libgeoip-dev libssl-dev python-dev zlib1g-dev libmagic-dev swig2.0 ca-certificates supervisor --no-install-recommends

# Compile and install bro
USER bro
WORKDIR /home/bro
RUN wget --no-check-certificate https://www.bro.org/downloads/release/2.4.1.tar.gz &amp;&amp; tar -xzf 2.4.1.tar.gz
WORKDIR /home/bro/2.4.1.tar.gz
RUN ./configure --prefix=/opt/bro &amp;&amp; make
USER root
RUN make install
RUN chmod u+s $PREFIX/bin/$PROG
RUN chmod u+s $PREFIX/bin/broctl
RUN chmod u+s $PREFIX/bin/capstats

# Supervisord
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Cleanup
RUN rm -rf /home/bro/bro-2.4.1

# Environment
WORKDIR /home/bro
USER root
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]