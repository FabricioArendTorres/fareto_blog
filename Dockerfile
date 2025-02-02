FROM alpine:latest AS builder
LABEL description="Docker Container for Hugo within Coolify."
LABEL maintainer="Fabricio Arend Torres"
WORKDIR /app

# config
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo

# copy and build static pages
COPY ./app /app
RUN hugo --destination public

# Stage 2: Serve the static site using Nginx
FROM nginx:alpine


COPY --from=builder /app/public /usr/share/nginx/html

# Set appropriate permissions for the static files
RUN chown -R nginx:nginx /usr/share/nginx/html

# web requests will come in at this port
EXPOSE 8080 

# Use the non-root user for running the server
CMD ["nginx", "-g", "daemon off;"]
