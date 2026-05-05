FROM nginx:1.27-alpine

# Custom server config (allows reading /.env used by frontend script)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Runtime env generator for frontend (.env served as static file)
COPY docker-entrypoint.d/40-generate-frontend-env.sh /docker-entrypoint.d/40-generate-frontend-env.sh
RUN chmod +x /docker-entrypoint.d/40-generate-frontend-env.sh

# Static site files
COPY . /usr/share/nginx/html

EXPOSE 80
