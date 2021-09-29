FROM python:3.9.7-alpine

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
ARG CHECKSUM_SHA512
LABEL maintainer="palon7@gmail.com" \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.name="Electrum-mona wallet (RPC enabled)" \
	org.label-schema.description="Electrum-mona wallet with JSON-RPC enabled (daemon mode)" \
	org.label-schema.version=$VERSION \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.vcs-url="https://github.com/palon7/docker-electrum-mona-daemon" \
	org.label-schema.usage="https://github.com/palon7/docker-electrum-mona-daemon#getting-started" \
	org.label-schema.license="MIT" \
	org.label-schema.url="https://electrum-mona.org/" \
	org.label-schema.docker.cmd='docker run -d --name electrum-mona-daemon --publish 127.0.0.1:7000:7000 --volume /srv/electrum-mona:/data palon7/electrum-mona-daemon' \
	org.label-schema.schema-version="1.0"

ENV ELECTRUM_VERSION $VERSION
ENV ELECTRUM_USER electrum
ENV ELECTRUM_PASSWORD electrumz
ENV ELECTRUM_HOME /root
ENV ELECTRUM_NETWORK mainnet

# IMPORTANT: always verify gpg signature before changing a hash here!
ENV ELECTRUM_CHECKSUM_SHA512 $CHECKSUM_SHA512

RUN apk --no-cache add libsecp256k1 && \
    apk --no-cache add --virtual build-dependencies gcc musl-dev libffi-dev cargo && \
    wget https://github.com/wakiyamap/electrum-mona/releases/download/${ELECTRUM_VERSION}/Electrum-MONA-${ELECTRUM_VERSION}.tar.gz && \
    [ "${ELECTRUM_CHECKSUM_SHA512}  Electrum-MONA-${ELECTRUM_VERSION}.tar.gz" = "$(sha512sum Electrum-MONA-${ELECTRUM_VERSION}.tar.gz)" ] && \
    echo -e "**************************\n SHA 512 Checksum OK\n**************************" && \
    pip3 install cryptography && \
    pip3 install Electrum-MONA-${ELECTRUM_VERSION}.tar.gz && \
    rm -f Electrum-MONA-${ELECTRUM_VERSION}.tar.gz && \
    apk del build-dependencies

RUN mkdir -p /data/ && \
	  ln -sf /data/ ${ELECTRUM_HOME}/.electrum-mona

WORKDIR $ELECTRUM_HOME
VOLUME /data
EXPOSE 7000

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["electrum-mona"]
