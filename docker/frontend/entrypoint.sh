#!/bin/sh
set -e
cd /app

# 1. Primer arranque: si la carpeta frontend/ está vacía, crea un proyecto React con Vite
if [ ! -f package.json ]; then
    echo ">> No hay proyecto React en frontend/. Creando uno nuevo con Vite..."
    npx --yes create-vite@latest /tmp/react --template react --no-interactive --no-immediate
    cp -a /tmp/react/. /app/
    rm -rf /tmp/react
fi

# 2. Dependencias de npm (se guardan en el volumen frontend_node_modules)
if [ ! -x node_modules/.bin/vite ]; then
    echo ">> Instalando dependencias de npm..."
    npm install
fi

exec "$@"
