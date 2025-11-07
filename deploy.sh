#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════
#  🚀 Script de Despliegue - Vecinity Landing Page Optimizada
# ═══════════════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════════════════"
echo "   🚀 Desplegando Vecinity Landing Page Optimizada"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables (ajusta según tu servidor)
SERVER="usuario@servidor"
REMOTE_PATH="/opt/docker/pagina_vecinity"
LOCAL_PATH="."

echo -e "${BLUE}📦 Verificando archivos locales...${NC}"
echo ""

# Verificar que existen los archivos optimizados
if [ ! -f "script.min.js" ]; then
    echo -e "${YELLOW}⚠️  script.min.js no encontrado${NC}"
    exit 1
fi

if [ ! -f "styles.min.css" ]; then
    echo -e "${YELLOW}⚠️  styles.min.css no encontrado${NC}"
    exit 1
fi

if [ ! -f "index.html" ]; then
    echo -e "${YELLOW}⚠️  index.html no encontrado${NC}"
    exit 1
fi

# Mostrar tamaños de archivos
echo -e "${GREEN}✅ Archivos encontrados:${NC}"
ls -lh script.min.js styles.min.css index.html | awk '{print "   "$9" → "$5}'
echo ""

# Confirmar despliegue
echo -e "${YELLOW}¿Deseas continuar con el despliegue? (s/n)${NC}"
read -r response
if [[ ! "$response" =~ ^[Ss]$ ]]; then
    echo "❌ Despliegue cancelado"
    exit 0
fi

echo ""
echo -e "${BLUE}📤 Subiendo archivos al servidor...${NC}"
echo ""

# Subir archivos
scp index.html "$SERVER:$REMOTE_PATH/" && echo -e "${GREEN}✅ index.html subido${NC}"
scp script.min.js "$SERVER:$REMOTE_PATH/" && echo -e "${GREEN}✅ script.min.js subido${NC}"
scp styles.min.css "$SERVER:$REMOTE_PATH/" && echo -e "${GREEN}✅ styles.min.css subido${NC}"

# Subir imágenes optimizadas
echo ""
echo -e "${BLUE}🖼️  Subiendo imágenes optimizadas...${NC}"
scp assets/images/logo.png "$SERVER:$REMOTE_PATH/assets/images/" && echo -e "${GREEN}✅ logo.png subido${NC}"
scp assets/images/favicon-*.png "$SERVER:$REMOTE_PATH/assets/images/" && echo -e "${GREEN}✅ favicons subidos${NC}"
scp assets/images/android-chrome-*.png "$SERVER:$REMOTE_PATH/assets/images/" && echo -e "${GREEN}✅ android icons subidos${NC}"
scp assets/images/apple-touch-icon.png "$SERVER:$REMOTE_PATH/assets/images/" && echo -e "${GREEN}✅ apple icon subido${NC}"

# Subir archivos de configuración
echo ""
echo -e "${BLUE}⚙️  Subiendo archivos de configuración...${NC}"
scp sitemap.xml "$SERVER:$REMOTE_PATH/" && echo -e "${GREEN}✅ sitemap.xml subido${NC}"
scp robots.txt "$SERVER:$REMOTE_PATH/" && echo -e "${GREEN}✅ robots.txt subido${NC}"
scp manifest.json "$SERVER:$REMOTE_PATH/" && echo -e "${GREEN}✅ manifest.json subido${NC}"
scp favicon.ico "$SERVER:$REMOTE_PATH/" && echo -e "${GREEN}✅ favicon.ico subido${NC}"

echo ""
echo -e "${BLUE}🔄 Reiniciando nginx...${NC}"
ssh "$SERVER" "cd $REMOTE_PATH && docker-compose restart nginx"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Nginx reiniciado correctamente${NC}"
else
    echo -e "${YELLOW}⚠️  Error al reiniciar nginx${NC}"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Despliegue completado exitosamente${NC}"
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
echo -e "${BLUE}📊 Verificación:${NC}"
echo "   1. Abre: https://vecinity.mx"
echo "   2. Verifica en DevTools → Network:"
echo "      • script.min.js: ~5 KB ✅"
echo "      • styles.min.css: ~2 KB ✅"
echo "      • logo.png: ~14 KB ✅"
echo ""
echo -e "${BLUE}🚀 PageSpeed Insights:${NC}"
echo "   https://pagespeed.web.dev/?url=https://vecinity.mx"
echo ""
echo -e "${BLUE}💡 Limpia cache del navegador:${NC}"
echo "   Ctrl/Cmd + Shift + R"
echo ""
echo "═══════════════════════════════════════════════════════════════════════"
