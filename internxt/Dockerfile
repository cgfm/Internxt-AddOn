FROM internxt/webdav:latest

# Install bashio for Home Assistant integration
RUN apk add --no-cache \
    bash \
    jq \
    curl

# Install bashio
RUN curl -L https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz | tar xzf - -C /tmp \
    && mv /tmp/bashio-0.16.2/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio-0.16.2

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
