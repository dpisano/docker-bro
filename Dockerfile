# Bro Sandbox - Bro 2.5
#
FROM alpine:3.5

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

RUN apk add --no-cache zlib openssl libstdc++ libpcap geoip libgcc tini bash
RUN apk add --no-cache -t .build-deps \
                          linux-headers \
                          openssl-dev \
                          libpcap-dev \
                          python-dev \
                          geoip-dev \
                          zlib-dev \
                          binutils \
                          fts-dev \
                          cmake \
                          clang \
                          bison \
                          perl \
                          make \
                          flex \
                          git \
                          g++ \
                          fts \
                          swig && \
    wget https://www.bro.org/downloads/$PROG-$VERS.$EXT && \
    tar -xzf $PROG-$VERS.$EXT && \
    rm -rf ./$PROG-$VERS.$EXT && \
    cd $PROG-$VERS && \
    CC=clang ./configure --prefix=$PREFIX && \
    make && \
    make install && \
    cd .. \
    rm -rf $PROG-$VERS && \
    chmod u+s $PREFIX/bin/$PROG ; \
    chmod u+s $PREFIX/bin/broctl ; \
    chmod u+s $PREFIX/bin/capstats ; \
    strip -s $PREFIX && \
    rm -rf /var/cache/apk/* && \
    apk del --purge .build-deps

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME  /opt/bro/logs /opt/bro/spool /opt/bro/etc
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
