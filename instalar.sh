#!/bin/bash

echo "=============================="
echo "  INSTALANDO HOTELINK"
echo "=============================="

if ! command -v curl &> /dev/null; then
    echo "Instalando curl..."
    sudo apt-get update
    sudo apt-get install -y curl
fi

if ! command -v docker &> /dev/null; then
    echo "Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    echo "Docker instalado."
else
    echo "Docker ya está instalado."
fi

sudo chmod 666 /var/run/docker.sock

if ! command -v git &> /dev/null; then
    echo "Instalando Git..."
    sudo apt-get update
    sudo apt-get install -y git
    echo "Git instalado."
else
    echo "Git ya está instalado."
fi

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

echo "Levantando Hotelink..."
sudo docker compose up --build -d

echo "Esperando a que el backend arranque..."
sleep 20

echo "=============================="
echo "  HOTELINK LISTO!"
echo "  Abre: http://localhost"
echo "=============================="