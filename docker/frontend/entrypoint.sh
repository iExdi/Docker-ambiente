#!/bin/sh
set -e
cd /app

# Creación del proyecto React
if [ ! -f package.json ]; then
    echo ">> No hay proyecto React en frontend/. Creando uno nuevo con Vite..."
    npx --yes create-vite@latest /tmp/react --template react --no-interactive --no-immediate
    cp -a /tmp/react/. /app/
    rm -rf /tmp/react
fi

# Dependencias de npm
if [ ! -x node_modules/.bin/vite ]; then
    echo ">> Instalando dependencias de npm..."
    npm install
fi

exec "$@"
