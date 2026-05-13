#!/bin/bash

echo "=============================="
echo "  INSTALANDO HOTELINK"
echo "=============================="

# Instalar curl si no está
if ! command -v curl &> /dev/null; then
    echo "Instalando curl..."
    sudo apt-get update
    sudo apt-get install -y curl
fi

# Instalar Docker si no está
if ! command -v docker &> /dev/null; then
    echo "Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    echo "Docker instalado."
else
    echo "Docker ya está instalado."
fi

# Permisos Docker
sudo chmod 666 /var/run/docker.sock

# Instalar Git si no está
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
sudo docker compose up --build -d

# Esperar a que postgres esté listo
echo "Esperando a que la base de datos esté lista..."
sleep 15

# Importar datos si existe el backup
if [ -f "hotelink_backup.sql" ]; then
    echo "Importando datos..."
    sudo docker exec -i hotelink-postgres psql -U hotelink_user -d hotelink -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
    sudo docker cp hotelink_backup.sql hotelink-postgres:/tmp/
    sudo docker exec -i hotelink-postgres psql -U hotelink_user -d hotelink -f /tmp/hotelink_backup.sql
    sudo docker restart hotelink-backend
    echo "Datos importados."
else
    echo "No se encontró hotelink_backup.sql, saltando importación."
fi

echo "=============================="
echo "  HOTELINK LISTO!"
echo "  Abre: http://localhost"
echo "=============================="