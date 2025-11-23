# Multi-stage build - get internxt from their official image
FROM internxt/webdav:latest AS internxt-source

# Use Home Assistant base image
ARG BUILD_FROM
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install requirements
RUN \
    apk add --no-cache \
        bash \
        jq \
        nodejs \
        npm

# Install bashio for Home Assistant integration
RUN \
    apk add --no-cache --virtual .build-dependencies \
        curl \
    && mkdir -p /tmp/bashio \
    && curl -L -s \
        "https://github.com/hassio-addons/bashio/archive/v0.16.2.tar.gz" \
        | tar -xzf - --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio \
    && apk del --no-cache --purge .build-dependencies

# Copy the internxt CLI and dependencies from official image
COPY --from=internxt-source /usr/local /usr/local
COPY --from=internxt-source /app /app

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="cgfm"
