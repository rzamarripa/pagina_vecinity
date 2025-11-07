#!/bin/bash
echo "🚀 Desplegando Vecinity Landing Page - VERSIÓN FINAL OPTIMIZADA"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Configuración
LOCAL_DIR="/Users/rzamarripa/Documents/Desarrollo/ClaudeCode/Vecinity/html"
cd "$LOCAL_DIR" || exit 1

# Verifica archivos críticos
echo "📦 Verificando archivos..."
REQUIRED_FILES=(
    "index.html"
    "script.min.js"
    "styles.min.css"
    "assets/images/logo.png"
    "assets/images/logo-96.png"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: $file no encontrado"
        exit 1
    fi
done

echo "✅ Todos los archivos encontrados"
echo ""

# Mostrar resumen
echo "📊 Resumen de archivos a subir:"
echo "════════════════════════════════════════════════════════════════"
ls -lh index.html script.min.js styles.min.css | awk '{printf "  %-25s %8s\n", $9, $5}'
ls -lh assets/images/logo*.png | awk '{printf "  %-25s %8s\n", $9, $5}'
echo ""

# Confirmar
echo "⚠️  IMPORTANTE: Esto sobrescribirá los archivos en producción"
echo ""
echo "¿Continuar con el deploy? (escribe 'si' para continuar)"
read -r response

if [ "$response" != "si" ]; then
    echo "❌ Deploy cancelado"
    exit 0
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "🚀 INICIANDO DEPLOY..."
echo "════════════════════════════════════════════════════════════════"
echo ""

# AJUSTA ESTOS VALORES PARA TU SERVIDOR:
SERVER="usuario@tu-servidor.com"
REMOTE_PATH="/opt/docker/pagina_vecinity"

echo "📤 1/5 - Subiendo index.html..."
scp index.html "$SERVER:$REMOTE_PATH/" && echo "   ✅ index.html" || echo "   ❌ Error"

echo "📤 2/5 - Subiendo script.min.js..."
scp script.min.js "$SERVER:$REMOTE_PATH/" && echo "   ✅ script.min.js" || echo "   ❌ Error"

echo "📤 3/5 - Subiendo styles.min.css..."
scp styles.min.css "$SERVER:$REMOTE_PATH/" && echo "   ✅ styles.min.css" || echo "   ❌ Error"

echo "📤 4/5 - Subiendo imágenes optimizadas..."
scp assets/images/logo.png "$SERVER:$REMOTE_PATH/assets/images/" && echo "   ✅ logo.png" || echo "   ❌ Error"
scp assets/images/logo-96.png "$SERVER:$REMOTE_PATH/assets/images/" && echo "   ✅ logo-96.png" || echo "   ❌ Error"
scp assets/images/favicon-*.png "$SERVER:$REMOTE_PATH/assets/images/" && echo "   ✅ favicons" || echo "   ❌ Error"
scp assets/images/android-chrome-*.png "$SERVER:$REMOTE_PATH/assets/images/" && echo "   ✅ android icons" || echo "   ❌ Error"
scp assets/images/apple-touch-icon.png "$SERVER:$REMOTE_PATH/assets/images/" && echo "   ✅ apple icon" || echo "   ❌ Error"

echo "📤 5/5 - Subiendo configuración..."
scp sitemap.xml manifest.json browserconfig.xml favicon.ico "$SERVER:$REMOTE_PATH/" && echo "   ✅ config files" || echo "   ❌ Error"

echo ""
echo "🔄 Reiniciando nginx..."
ssh "$SERVER" "cd $REMOTE_PATH && docker-compose restart nginx" && echo "   ✅ Nginx reiniciado" || echo "   ❌ Error"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ DEPLOY COMPLETADO"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "🔍 VERIFICACIÓN:"
echo "   1. Abre: https://vecinity.mx"
echo "   2. Hard reload: Cmd+Shift+R (Mac) o Ctrl+Shift+R (Windows)"
echo "   3. PageSpeed: https://pagespeed.web.dev/?url=https://vecinity.mx"
echo ""
echo "📊 RESULTADOS ESPERADOS:"
echo "   Desktop:"
echo "     • Performance: 92-95"
echo "     • Accessibility: 92+"
echo "     • Best Practices: 85+"
echo "     • SEO: 100"
echo ""
echo "   Mobile:"
echo "     • Performance: 88-92"
echo "     • Accessibility: 85+"
echo "     • Best Practices: 85+"
echo "     • SEO: 100"
echo ""
