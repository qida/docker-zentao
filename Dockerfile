FROM alpine
LABEL maintainer="sunqida@foxmail.com"

#RUN apk update && apk add apache2 mariadb-server php php-curl php-gd php-ldap php-mbstring php-mcrypt php-mysql php-xml php-zip php-cli php-json curl unzip libapache2-mod-php locales
RUN apk update && apk add php7-apache2 mariadb php7 php7-curl php7-gd php7-ldap php7-mbstring php7-ctype php7-pecl-mcrypt php7-pdo_mysql php7-xml php7-zip php7-json curl unzip
ENV LANG="en_US.UTF8"
ENV MYSQL_ROOT_PASSWORD="123456"
RUN echo -e "LANG=\"en_US.UTF-8\"\nLANGUAGE=\"en_US:en\"" > /etc/default/locale && locale-gen en_US.UTF-8

RUN mkdir -p /app/zentaopms
COPY docker-entrypoint.sh /app
RUN chmod 777 /app/docker-entrypoint.sh
RUN random=`date +%s`; curl http://cdn.zentaopm.com/latest/zentao.zip?rand=$random -o /var/www/zentao.zip
RUN cd /var/www/ && unzip -q zentao.zip && rm zentao.zip
RUN a2enmod rewrite

RUN rm -rf /etc/apache2/sites-enabled/000-default.conf /var/lib/mysql/*
RUN sed -i '1i ServerName 127.0.0.1' /etc/apache2/apache2.conf
COPY config/apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY config/ioncube_loader_lin_7.0.so /usr/lib/php/20151012/ioncube_loader_lin_7.0.so
COPY config/00-ioncube.ini /etc/php/7.0/apache2/conf.d/
COPY config/00-ioncube.ini /etc/php/7.0/cli/conf.d/

VOLUME /app/zentaopms /var/lib/mysql
ENTRYPOINT ["/app/docker-entrypoint.sh"]
