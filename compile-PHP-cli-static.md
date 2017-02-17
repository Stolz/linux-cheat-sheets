# Compile static PHP cli

Get sources (replace `PHP-7.1.2` with the latest version)

    git clone git@github.com:php/php-src.git -b PHP-7.1.2 && cd php-src

Create configure script

    ./buildconf --force

List all configure options

    ./configure --help

Configure

    ./configure \
    --enable-static=yes \
    --enable-shared=no \
    --disable-all \
    --enable-json \
    --enable-libxml \
    --enable-mbstring \
    --enable-phar \
    --enable-soap \
    --enable-xml \
    --with-curl \
    --with-openssl \
    --without-pear

Compile

    make -j 5

The static binary file will be located at `./sapi/cli/php`.

To list compiled modules

    ./sapi/cli/php -m

To test in-line

    ./sapi/cli/php -r 'echo var_export($argv, true);' a 1 b 2 c 3

