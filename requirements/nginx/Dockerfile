FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/html/*

COPY ./config.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /etc/nginx/ssl 
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/CN=$DOMAIN_NAME"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]