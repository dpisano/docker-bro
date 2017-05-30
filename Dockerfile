# Bro Sandbox - Bro 2.5
#
# VERSION               1.0
FROM      alpine
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
ENV VERS 2.5
# Install directory
ENV PREFIX /opt/bro
# Path should include prefix
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PREFIX/bin

RUN apk add --update cmake make gcc g++ bison flex libpcap-dev openssl-dev zlib-dev python-dev perl wget file supervisor swig bash && \
    wget --no-check-certificate https://www.bro.org/downloads/$PROG-$VERS.$EXT && \
    tar -xzf $PROG-$VERS.$EXT && \
    rm -rf ./$PROG-$VERS.$EXT && \
    cd $PROG-$VERS && \
    ./configure --prefix=$PREFIX && \
    make && \
    make install && \
    cd .. \
    rm -rf $PROG-$VERS && \
    chmod u+s $PREFIX/bin/$PROG ; \
    chmod u+s $PREFIX/bin/broctl ; \
    chmod u+s $PREFIX/bin/capstats ; \
    apk del cmake make gcc g++ bison flex zlib-dev python-dev wget file swig
    rm -rf /var/cache/apk/*

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME  /opt/bro/logs /opt/bro/spool /opt/bro/etc
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
