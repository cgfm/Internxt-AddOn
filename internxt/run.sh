#!/usr/bin/with-contenv bashio

# Read configuration
INXT_USER=$(bashio::config 'inxt_user')
INXT_PASSWORD=$(bashio::config 'inxt_password')
INXT_TWOFACTORCODE=$(bashio::config 'inxt_twofactorcode')
INXT_OTPTOKEN=$(bashio::config 'inxt_otptoken')
WEBDAV_PORT=$(bashio::config 'webdav_port')
WEBDAV_PROTOCOL=$(bashio::config 'webdav_protocol')

bashio::log.info "Starting Internxt WebDAV server..."

# Check required configuration
if bashio::config.is_empty 'inxt_user'; then
    bashio::exit.nok "Internxt username/email is required!"
fi

if bashio::config.is_empty 'inxt_password'; then
    bashio::exit.nok "Internxt password is required!"
fi

# Set environment variables for the Internxt WebDAV container
export INXT_USER="${INXT_USER}"
export INXT_PASSWORD="${INXT_PASSWORD}"
export WEBDAV_PORT="${WEBDAV_PORT}"
export WEBDAV_PROTOCOL="${WEBDAV_PROTOCOL}"

# Handle 2FA configuration
if ! bashio::config.is_empty 'inxt_otptoken'; then
    export INXT_OTPTOKEN="${INXT_OTPTOKEN}"
    bashio::log.info "Using OTP token for automatic 2FA"
elif ! bashio::config.is_empty 'inxt_twofactorcode'; then
    export INXT_TWOFACTORCODE="${INXT_TWOFACTORCODE}"
    bashio::log.info "Using provided 2FA code"
fi

bashio::log.info "Configuration validated"
bashio::log.info "Internxt User: ${INXT_USER}"
bashio::log.info "WebDAV Protocol: ${WEBDAV_PROTOCOL}"
bashio::log.info "WebDAV Port: ${WEBDAV_PORT}"

# Start the WebDAV server
# The internxt/webdav image should have its own entrypoint
# We just need to set the environment and let it run
# Typical entrypoint might be node or npm start
# Check if there's a docker-entrypoint.sh or similar
if [ -f /docker-entrypoint.sh ]; then
    exec /docker-entrypoint.sh
elif [ -f /entrypoint.sh ]; then
    exec /entrypoint.sh
elif [ -f /usr/local/bin/docker-entrypoint.sh ]; then
    exec /usr/local/bin/docker-entrypoint.sh
else
    # Fallback: try common Node.js patterns
    if [ -f /app/package.json ]; then
        cd /app && exec npm start
    elif [ -f /usr/src/app/package.json ]; then
        cd /usr/src/app && exec npm start
    else
        bashio::log.error "Could not find Internxt WebDAV entrypoint!"
        bashio::exit.nok "Unable to start the application"
    fi
fi
