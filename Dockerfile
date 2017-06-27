# Bro Sandbox - Bro 2.5.1
#
# VERSION               1.0
FROM      debian

# Metadata
LABEL program=bro

# Specify container username e.g. training, demo
ENV VIRTUSER bro
# Specify program
ENV PROG bro
# Specify source extension
ENV EXT tar.gz
# Specify Bro version to download and install (e.g. bro-2.3.1, bro-2.4)
ENV VERS 2.5.1
# Install directory
ENV PREFIX /opt/bro
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin

RUN groupadd -r $VIRTUSER && \
    useradd -r -g $VIRTUSER $VIRTUSER && \
    mkdir /home/bro; chown -R bro:bro /home/bro

WORKDIR /home/$VIRTUSER
RUN apt-get update -qq && \
    apt-get install -yq build-essential cmake make gcc g++ flex bison libpcap-dev libgeoip-dev libssl-dev python-dev zlib1g-dev libmagic-dev swig ca-certificates supervisor wget --no-install-recommends && \
    wget --no-check-certificate https://www.bro.org/downloads/$PROG-$VERS.$EXT && \
    tar -xzf $PROG-$VERS.$EXT && \
    rm -rf /home/$VIRTUSER/$PROG-$VERS.$EXT && \
    cd /home/$VIRTUSER/$PROG-$VERS && \
    ./configure --prefix=$PREFIX && \
    make && \
    make install && \
    cd /home/$VIRTUSER && \
    rm -rf /home/$VIRTUSER/$PROG-$VERS && \
    chmod u+s $PREFIX/bin/$PROG ; \
    chmod u+s $PREFIX/bin/broctl ; \
    chmod u+s $PREFIX/bin/capstats ;\
    apt-get purge -y build-essential cmake make gcc g++ flex bison zlib1g-dev python-dev zlib1g-dev libmagic-dev swig && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME  /opt/bro/logs /opt/bro/spool /opt/bro/etc
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
