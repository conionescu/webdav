FROM ubuntu:14.04

RUN apt-get update && apt-get install -y apache2 apache2-utils
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN a2enmod ssl dav_fs
RUN rm /etc/apache2/sites-enabled/*
RUN mkdir -p /dav/data
RUN chown -R www-data /dav

ADD dav.conf /etc/apache2/sites-enabled/
ADD dav_ssl.conf /etc/apache2/sites-enabled/

EXPOSE 80
EXPOSE 443
VOLUME /dav
VOLUME /certs

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["/usr/sbin/apache2ctl", "-D",  "FOREGROUND"]

