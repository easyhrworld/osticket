FROM php:7-cli as builder
RUN apt update && apt install git -y
WORKDIR /app
RUN git clone https://github.com/osTicket/osTicket && \
    cd osTicket && php manage.php deploy --setup /app/osticket/ && \
    rm -rf /app/osticket/setup

FROM php:7-apache
COPY --from builder /app/osticket/ /var/www/html
