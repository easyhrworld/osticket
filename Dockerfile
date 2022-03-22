FROM php:7-cli as builder
RUN apt update && apt install git -y
WORKDIR /app
RUN git clone https://github.com/osTicket/osTicket && \
    cd osTicket && php manage.php deploy --setup /app/osticket/ && \
    mv /app/osticket/include/ost-sampleconfig.php /app/osticket/include/ost-config.php 
RUN sed -i "s/define('OSTINSTALLED',FALSE);/define('OSTINSTALLED',TRUE);/" /app/osticket/include/ost-config.php && \
    sed -i "s/'%CONFIG-SIRI'/getenv('APP_KEY')/" /app/osticket/include/ost-config.php && \
    sed -i "s/'%ADMIN-EMAIL'/getenv('ADMIN_EMAIL')/" /app/osticket/include/ost-config.php && \
    sed -i "s/'%CONFIG-DBHOST'/getenv('DB_HOST')/" /app/osticket/include/ost-config.php && \
    sed -i "s/'%CONFIG-DBNAME'/getenv('DB_NAME')/" /app/osticket/include/ost-config.php && \
    sed -i "s/'%CONFIG-DBUSER'/getenv('DB_USER')/" /app/osticket/include/ost-config.php && \
    sed -i "s/'%CONFIG-DBPASS'/getenv('DB_PASS')/" /app/osticket/include/ost-config.php && \
    sed -i "s/'%CONFIG-PREFIX'/getenv('TABLE_PREFIX')/" /app/osticket/include/ost-config.php && \
    rm -rf /app/osticket/setup 

FROM php:7-apache
COPY --from=builder /app/osticket/ /var/www/html
