#!/bin/bash

##############################################################################
# Script de Instalación de Vecinity Landing Page en Ubuntu
# Autor: Vecinity Team
# Versión: 1.0
##############################################################################

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "═══════════════════════════════════════════════════════════════"
echo "   VECINITY LANDING PAGE - INSTALACIÓN EN UBUNTU"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

# Verificar que se ejecuta como root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script debe ejecutarse como root (usa sudo)${NC}"
   exit 1
fi

# Verificar sistema operativo
if [ ! -f /etc/os-release ]; then
    echo -e "${RED}No se puede determinar el sistema operativo${NC}"
    exit 1
fi

source /etc/os-release
if [[ "$ID" != "ubuntu" ]]; then
    echo -e "${YELLOW}Advertencia: Este script está optimizado para Ubuntu${NC}"
    read -p "¿Deseas continuar de todos modos? (s/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi

echo -e "${GREEN}✓ Sistema operativo detectado: $PRETTY_NAME${NC}"

# Actualizar sistema
echo -e "\n${BLUE}[1/6] Actualizando sistema...${NC}"
apt-get update -qq
apt-get upgrade -y -qq

# Instalar Docker
echo -e "\n${BLUE}[2/6] Instalando Docker...${NC}"
if ! command -v docker &> /dev/null; then
    # Instalar dependencias
    apt-get install -y -qq \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Agregar Docker GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Agregar repositorio
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Instalar Docker Engine
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io

    echo -e "${GREEN}✓ Docker instalado correctamente${NC}"
else
    echo -e "${GREEN}✓ Docker ya está instalado${NC}"
fi

# Instalar Docker Compose
echo -e "\n${BLUE}[3/6] Instalando Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    # Instalar Docker Compose v2 (plugin)
    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    # También instalar el comando docker-compose legacy
    ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

    echo -e "${GREEN}✓ Docker Compose instalado correctamente${NC}"
else
    echo -e "${GREEN}✓ Docker Compose ya está instalado${NC}"
fi

# Verificar versiones
echo -e "\n${BLUE}Versiones instaladas:${NC}"
docker --version
docker-compose --version

# Habilitar Docker en el arranque
echo -e "\n${BLUE}[4/6] Habilitando Docker en el arranque...${NC}"
systemctl enable docker
systemctl start docker
echo -e "${GREEN}✓ Docker habilitado${NC}"

# Configurar firewall (UFW)
echo -e "\n${BLUE}[5/6] Configurando firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw --force enable
    ufw allow 22/tcp comment 'SSH'
    ufw allow 80/tcp comment 'HTTP'
    ufw allow 443/tcp comment 'HTTPS'
    ufw status
    echo -e "${GREEN}✓ Firewall configurado${NC}"
else
    echo -e "${YELLOW}UFW no está instalado. Saltando configuración de firewall.${NC}"
fi

# Crear directorio de trabajo
echo -e "\n${BLUE}[6/6] Configurando aplicación...${NC}"
INSTALL_DIR="/opt/vecinity-landing"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}El directorio $INSTALL_DIR ya existe.${NC}"
    read -p "¿Deseas sobrescribirlo? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        rm -rf "$INSTALL_DIR"
    else
        echo -e "${RED}Instalación cancelada${NC}"
        exit 1
    fi
fi

mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}✓ Directorio creado: $INSTALL_DIR${NC}"

# Información final
echo -e "\n${GREEN}"
echo "═══════════════════════════════════════════════════════════════"
echo "   ✓ INSTALACIÓN COMPLETADA"
echo "═══════════════════════════════════════════════════════════════"
echo -e "${NC}"

echo -e "${BLUE}Próximos pasos:${NC}"
echo ""
echo "1. Copia los archivos de la landing page a: $INSTALL_DIR"
echo "   cd $INSTALL_DIR"
echo ""
echo "2. Inicia la aplicación:"
echo "   docker-compose up -d"
echo ""
echo "3. Verifica que esté funcionando:"
echo "   docker-compose ps"
echo "   curl http://localhost"
echo ""
echo "4. Ver logs:"
echo "   docker-compose logs -f"
echo ""
echo "5. Detener la aplicación:"
echo "   docker-compose down"
echo ""

# Información del servidor
IP=$(hostname -I | awk '{print $1}')
echo -e "${GREEN}Tu servidor estará disponible en:${NC}"
echo "   http://$IP"
echo "   http://localhost (desde el servidor)"
echo ""

echo -e "${YELLOW}Nota: Para HTTPS necesitarás configurar SSL con Let's Encrypt${NC}"
echo ""

echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}   ¡Instalación exitosa! 🚀${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
