# 2 stage process. First stage for building static files with hugo. Second stage for serving with nginx.
FROM alpine:latest AS builder
LABEL description="Docker Container for Hugo within Coolify."
LABEL maintainer="Fabricio Arend Torres"

WORKDIR /app

# install hugo
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo


# copy and build static pages
COPY ./app /app
RUN hugo --destination public

# Development Stage: Run Hugo server (only for dev)
FROM builder AS dev
CMD ["hugo", "server", "--bind", "0.0.0.0", "--baseURL", "/", "-p", "80"]


#####################################################
# Stage 2: Serve the static site using Nginx
FROM nginx:alpine AS prod
# COPY nginx.template.conf /etc/nginx/templates/default.conf.template

ARG GA4_MEASUREMENT_ID   
ENV GA4_MEASUREMENT_ID=${GA4_MEASUREMENT_ID}


COPY --from=builder /app/public /usr/share/nginx/html

# Set appropriate permissions for the static files
# Note: the nginx base image already has the nginx user !
RUN chown -R nginx:nginx /usr/share/nginx/html

