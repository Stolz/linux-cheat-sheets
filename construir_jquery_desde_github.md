# Construir jQuery a partir del código fuente de GitHub

## Dependencias:
emerge -n net-libs/nodejs
npm install -g grunt

## Obtener el codigo:
git clone git://github.com/jquery/jquery.git
cd jquery && npm install

## Generar los ficheros comprimidos:
grunt

Los ficheros se generan en dist/