FROM nginx:1.27-alpine
# Build marker: 2026-05-05-01

# Custom server config (allows reading /.env used by frontend script)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Runtime env generator for frontend (generated inside image to avoid missing build-context files)
RUN mkdir -p /docker-entrypoint.d && \
    printf '%s\n' \
    '#!/bin/sh' \
    'set -eu' \
    '' \
    'OUTPUT_FILE="/usr/share/nginx/html/config.js"' \
    'CTA_URL_VALUE="${CTA_URL:-https://www.advancedbionutritionals.com/DS24/Advanced-Amino/Muscle-Mass-Loss/HD.htm#aff=riseads}"' \
    'MODAL_VISIBILITY_VALUE="${MODAL_VISIBILITY:-true}"' \
    '' \
    'cat > "${OUTPUT_FILE}" <<EOF' \
    'window.APP_CONFIG = {' \
    '  CTA_URL: "${CTA_URL_VALUE}",' \
    '  MODAL_VISIBILITY: ${MODAL_VISIBILITY_VALUE}' \
    '};' \
    'EOF' \
    '' \
    'echo "Generated runtime config at ${OUTPUT_FILE}"' \
    > /docker-entrypoint.d/40-generate-frontend-env.sh && \
    chmod +x /docker-entrypoint.d/40-generate-frontend-env.sh

# Static site files
COPY . /usr/share/nginx/html

EXPOSE 80
