FROM php:8.2-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libldap2-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libbz2-dev \
    libonig-dev \
    libsodium-dev \
    libgd-dev \
    cron \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP requeridas por GLPI
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        intl \
        ldap \
        mysqli \
        opcache \
        zip \
        xml \
        curl \
        bz2 \
        mbstring \
        sodium \
        exif

# Habilitar módulos Apache
RUN a2enmod rewrite

# Configurar PHP
RUN echo "memory_limit = 64M" >> /usr/local/etc/php/conf.d/glpi.ini \
    && echo "file_uploads = On" >> /usr/local/etc/php/conf.d/glpi.ini \
    && echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/glpi.ini \
    && echo "session.auto_start = 0" >> /usr/local/etc/php/conf.d/glpi.ini \
    && echo "session.use_trans_sid = 0" >> /usr/local/etc/php/conf.d/glpi.ini

# Configurar DocumentRoot de Apache apuntando a /public de GLPI
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copiar el código de la aplicación
COPY . /var/www/html/

# Crear directorios necesarios y ajustar permisos
RUN mkdir -p /var/www/html/files \
    && mkdir -p /var/www/html/config \
    && mkdir -p /var/www/html/marketplace \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 /var/www/html/files \
    && chmod -R 777 /var/www/html/config \
    && chmod -R 777 /var/www/html/marketplace

WORKDIR /var/www/html

EXPOSE 80
