# Bro Sandbox - Bro 2.4.1
#
# VERSION               1.0
FROM      debian
MAINTAINER David Pisano

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
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin

RUN groupadd -r $VIRTUSER && \
    useradd -r -g $VIRTUSER $VIRTUSER && \
    mkdir /home/bro; chown -R bro:bro /home/bro

WORKDIR /home/$VIRTUSER

RUN apt-get update -qq
RUN apt-get install -yq wget
RUN wget -qO - http://download.opensuse.org/repositories/network:bro/Debian_8.0/Release.key | apt-key add -
RUN echo 'deb http://download.opensuse.org/repositories/network:/bro/Debian_8.0/ /' >> /etc/apt/sources.list.d/bro.list
RUN apt-get update -qq
RUN apt-get install bro
RUN apt-get purge -y wget
RUN apt-get autoremove -y
RUN apt-get clean
RUN apt-get purge
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME  /opt/bro/logs /opt/bro/spool /opt/bro/etc
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
