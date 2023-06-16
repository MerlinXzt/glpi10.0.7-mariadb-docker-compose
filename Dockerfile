# Utiliza la imagen oficial de PHP 8.1 con Apache como base
FROM php:8.1-apache

LABEL maintainer="Carlos Armoa <carlosgabrielarmoa@gmail.com>"

# Definir las constantes GLPI_VAR_DIR y GLPI_CONFIG_DIR
ENV GLPI_VAR_DIR=/var/glpi-files
ENV GLPI_CONFIG_DIR=/var/glpi-config

# Instala las dependencias requeridas por GLPI y otras herramientas
RUN apt-get update && apt-get install -y \
    libldap2-dev \
    libbz2-dev \
    libldb-dev \
    zlib1g-dev \
    libicu-dev \
    libxml2-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libzip-dev \
    unzip \
    curl

# Habilita los módulos de Apache necesarios
RUN a2enmod rewrite headers

# Establece la zona horaria
ENV TZ=America/Asuncion
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instala las extensiones PHP requeridas por GLPI y Marketplace
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) \
    gd \
    intl \
    ldap \
    pdo_mysql \
    mysqli \
    zip \
    opcache \
    bcmath \
    exif \
    xml \
    bz2

RUN apt-get update && apt-get install -y libpq-dev
RUN apt-get update && apt-get install -y mariadb-client
# Configuración de seguridad para sesiones
RUN echo "session.cookie_httponly = On" >> /usr/local/etc/php/conf.d/security.ini

# Descarga y descomprime GLPI
RUN curl -L -o glpi.tar.gz https://github.com/glpi-project/glpi/releases/download/10.0.7/glpi-10.0.7.tgz && \
    tar -xvzf glpi.tar.gz && \
    rm glpi.tar.gz && \
    mkdir -p /var/www/html/public && \
    mv glpi/* /var/www/html/public

# Cambia los permisos de los directorios de datos GLPI
RUN mkdir -p /var/glpi-files
RUN mkdir -p /var/glpi-config
RUN mkdir -p /var/glpi-files/_cache 
RUN mkdir -p /var/glpi-files/_cron 
RUN mkdir -p /var/glpi-files/_dumps 
RUN mkdir -p /var/glpi-files/_graphs 
RUN mkdir -p /var/glpi-files/_lock 
RUN mkdir -p /var/glpi-files/_pictures
RUN mkdir -p /var/glpi-files/_plugins 
RUN mkdir -p /var/glpi-files/_rss 
RUN mkdir -p /var/glpi-files/_sessions 
RUN mkdir -p /var/glpi-files/_tmp 
RUN mkdir -p /var/glpi-files/_uploads 
RUN chown -R www-data:www-data /var/glpi-files 
RUN chmod -R 777 /var/glpi-files
RUN chown -R www-data:www-data /var/glpi-config
RUN chown -R www-data:www-data /var/glpi-config
RUN chown -R www-data:www-data /var/glpi-files/_cache 
RUN chown -R www-data:www-data /var/glpi-files/_cron 
RUN chown -R www-data:www-data /var/glpi-files/_dumps 
RUN chown -R www-data:www-data /var/glpi-files/_graphs
RUN chown -R www-data:www-data /var/glpi-files/_lock
RUN chown -R www-data:www-data /var/glpi-files/_pictures 
RUN chown -R www-data:www-data /var/glpi-files/_plugins 
RUN chown -R www-data:www-data /var/glpi-files/_rss 
RUN chown -R www-data:www-data /var/glpi-files/_sessions 
RUN chown -R www-data:www-data /var/glpi-files/_tmp 
RUN chown -R www-data:www-data /var/glpi-files/_uploads 


# Crea el archivo config_db.php

RUN mkdir -p /var/www/html/public/glpi/config
RUN touch /var/www/html/public/glpi/config/config_db.php && \
    echo "<?php" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_TYPE', 'mysqli');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_HOST', 'db');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_NAME', 'glpi_db');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_USER', 'glpi');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_PASSWORD', 'glpi_password');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_PORT', '3306');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_PERSISTENT', false);" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_CHARSET', 'utf8');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_SQL_MODE', '');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('DB_PREFIX', 'glpi_');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_USE_SSL', false);" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_ROOT', '/var/www/html');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_VAR_DIR', '/var/glpi-files');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_LOG_DIR', '/var/www/html/files/_log');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_CONFIG_DIR', '/var/glpi-config');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_USE_MODE', 'prod');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_JQUERY_VERSION', '3.6.0');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_FORCE_CSS', false);" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_FORCE_JS', false);" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_FORCE_LANG', false);" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_NB_HOUR_DURATION', 744);" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "date_default_timezone_set('America/Asuncion');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "?>" >> /var/www/html/public/glpi/config/config_db.php

# Habilitar la zona horaria de Asunción, Paraguay
RUN ln -snf /usr/share/zoneinfo/America/Asuncion /etc/localtime && echo "America/Asuncion" > /etc/timezone

# Actualiza la configuración de GLPI para reflejar los nuevos directorios de datos
# Configura los directorios de datos fuera del directorio raíz web
RUN sed -i "/define('GLPI_VAR_DIR',/d" /var/www/html/public/glpi/config/config_db.php && \
    sed -i "/define('GLPI_CONFIG_DIR',/d" /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_VAR_DIR', '/var/glpi-files');" >> /var/www/html/public/glpi/config/config_db.php && \
    echo "define('GLPI_CONFIG_DIR', '/var/glpi-config');" >> /var/www/html/public/glpi/config/config_db.php


# Verifica si el archivo config_db.php existe y muestra su contenido
RUN cat /var/www/html/public/glpi/config/config_db.php

# Establece los permisos adecuados para los archivos de GLPI
RUN chown -R www-data:www-data /var/www/html/public && \
    chmod -R 755 /var/www/html/public

# Configura el archivo de host virtual de Apache
COPY apache-glpi.conf /etc/apache2/sites-available/glpi.conf

# Habilita el sitio de GLPI
RUN a2ensite glpi

# Deshabilita el sitio por defecto de Apache
RUN a2dissite 000-default

# Reinicia el servicio de Apachs
RUN service apache2 restart

# Expone el puerto 80 para acceder a GLPI desde el host
EXPOSE 80

