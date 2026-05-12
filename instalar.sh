#!/bin/bash

echo "=============================="
echo "  INSTALANDO HOTELINK"
echo "=============================="

# Instalar Docker si no está instalado
if ! command -v docker &> /dev/null; then
    echo "Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "Docker instalado."
else
    echo "Docker ya está instalado."
fi

# Instalar Git si no está instalado
if ! command -v git &> /dev/null; then
    echo "Instalando Git..."
    sudo apt-get update
    sudo apt-get install -y git
    echo "Git instalado."
else
    echo "Git ya está instalado."
fi

# Clonar repositorios
echo "Clonando repositorios..."

if [ ! -d "hotelink-backend" ]; then
    git clone https://github.com/Laura-diaz08/hotelink-backend.git
    echo "Backend clonado."
else
    echo "Backend ya existe, actualizando..."
    cd hotelink-backend && git pull && cd ..
fi

if [ ! -d "hotelink-frontend" ]; then
    git clone https://github.com/Laura-diaz08/hotelink-frontend.git
    echo "Frontend clonado."
else
    echo "Frontend ya existe, actualizando..."
    cd hotelink-frontend && git pull && cd ..
fi

# Levantar todo
echo "Levantando Hotelink..."
docker compose up --build -d

echo "=============================="
echo "  HOTELINK LISTO!"
echo "  Abre: http://localhost"
echo "=============================="