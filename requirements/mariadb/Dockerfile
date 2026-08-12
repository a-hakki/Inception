FROM debian:bookworm

# Install MariaDB and immediately wipe the default half-baked database
RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql/*

# Allow network connections
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY run.sh /etc/run.sh
RUN chmod +x /etc/run.sh

EXPOSE 3306

CMD ["/etc/run.sh"]