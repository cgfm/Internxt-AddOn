ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install requirements
RUN apk add --no-cache \
    bash \
    jq \
    nodejs \
    npm

# Install bashio
RUN apk add --no-cache curl \
    && curl -L https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz | tar xzf - -C /tmp \
    && mv /tmp/bashio-0.16.2/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio-0.16.2 \
    && apk del curl

# Install internxt-webdav from npm
RUN npm install -g @internxt/webdav-server

# Copy rootfs
COPY rootfs /

# Labels
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="cgfm" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="cgfm" \
    org.opencontainers.image.authors="cgfm" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/cgfm/internxt-addon" \
    org.opencontainers.image.source="https://github.com/cgfm/internxt-addon" \
    org.opencontainers.image.documentation="https://github.com/cgfm/internxt-addon/blob/master/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
