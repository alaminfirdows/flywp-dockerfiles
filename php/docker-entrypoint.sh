#!/bin/bash

# Set PHP memory_limit based on the PHP_MEMORY_LIMIT environment variable
if [ ! -z "${PHP_MEMORY_LIMIT}" ]; then
    sed -i "s/memory_limit = .*/memory_limit = ${PHP_MEMORY_LIMIT}/" /usr/local/etc/php/conf.d/memory.ini
fi

# Set OPCache and JIT configurations based on the OPCACHE_ENABLE and JIT_ENABLE environment variables
if [ ! -z "${OPCACHE_ENABLE}" ]; then
    sed -i "s/opcache.enable=.*/opcache.enable=${OPCACHE_ENABLE}/" /usr/local/etc/php/conf.d/opcache.ini
fi

# Set upload file size limit based on the UPLOAD_MAX_FILESIZE environment variable
if [ ! -z "${UPLOAD_MAX_FILESIZE}" ]; then
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = ${UPLOAD_MAX_FILESIZE}/" /usr/local/etc/php/conf.d/uploads.ini
    sed -i "s/post_max_size = .*/post_max_size = ${UPLOAD_MAX_FILESIZE}/" /usr/local/etc/php/conf.d/uploads.ini
fi

if [ ! -z "${JIT_ENABLE}" ]; then
    if [ "${JIT_ENABLE}" = "1" ]; then
        sed -i "s/opcache.jit_buffer_size=.*/opcache.jit_buffer_size=100M/" /usr/local/etc/php/conf.d/opcache.ini
    else
        sed -i "s/opcache.jit_buffer_size=.*/opcache.jit_buffer_size=0/" /usr/local/etc/php/conf.d/opcache.ini
    fi
fi

# Start php-fpm
exec "$@"
