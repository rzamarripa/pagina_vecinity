# 🔧 Instrucciones para Actualizar Nginx con Redirects 301

---

## 📋 Archivo Creado

He generado el archivo **`vecinity.conf`** corregido con todos los redirects 301.

---

## 🚀 Cómo Aplicar los Cambios en tu Servidor

### **Paso 1: Hacer Backup del Archivo Actual**

```bash
sudo cp /etc/nginx/sites-enabled/vecinity.conf /etc/nginx/sites-enabled/vecinity.conf.backup
```

### **Paso 2: Editar el Archivo**

Opción A - Editar directamente:
```bash
sudo nano /etc/nginx/sites-enabled/vecinity.conf
```

Opción B - Reemplazar con el nuevo archivo:
```bash
# Copiar el nuevo archivo al servidor (desde tu máquina local)
scp vecinity.conf usuario@tu-servidor:/tmp/

# Luego en el servidor:
sudo mv /tmp/vecinity.conf /etc/nginx/sites-enabled/vecinity.conf
```

### **Paso 3: Verificar la Configuración**

```bash
sudo nginx -t
```

**Salida esperada:**
```
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### **Paso 4: Recargar Nginx**

```bash
sudo systemctl reload nginx
```

O si prefieres reiniciar:
```bash
sudo systemctl restart nginx
```

### **Paso 5: Verificar el Estado**

```bash
sudo systemctl status nginx
```

---

## ✅ Verificar que los Redirects Funcionan

### **Test 1: HTTP → HTTPS**

```bash
curl -I http://vecinity.mx
```

**Resultado esperado:**
```
HTTP/1.1 301 Moved Permanently
Location: https://vecinity.mx/
```

### **Test 2: HTTP www → HTTPS non-www**

```bash
curl -I http://www.vecinity.mx
```

**Resultado esperado:**
```
HTTP/1.1 301 Moved Permanently
Location: https://vecinity.mx/
```

### **Test 3: HTTPS www → HTTPS non-www**

```bash
curl -I https://www.vecinity.mx
```

**Resultado esperado:**
```
HTTP/1.1 301 Moved Permanently
Location: https://vecinity.mx/
```

### **Test 4: HTTPS non-www (final)**

```bash
curl -I https://vecinity.mx
```

**Resultado esperado:**
```
HTTP/2 200
```

---

## 📊 Diagrama de Redirects

```
http://vecinity.mx          →  301  →  https://vecinity.mx  ✅
http://www.vecinity.mx      →  301  →  https://vecinity.mx  ✅
https://www.vecinity.mx     →  301  →  https://vecinity.mx  ✅
https://vecinity.mx         →  200 OK (página principal)    ✅
```

---

## 🔍 Qué Incluye la Nueva Configuración

### ✅ **1. Redirect HTTP → HTTPS (ambas versiones)**
```nginx
server {
    listen 80;
    server_name vecinity.mx www.vecinity.mx;
    return 301 https://vecinity.mx$request_uri;
}
```

### ✅ **2. Redirect HTTPS www → HTTPS non-www**
```nginx
server {
    listen 443 ssl http2;
    server_name www.vecinity.mx;
    ssl_certificate /etc/letsencrypt/live/vecinity.mx/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/vecinity.mx/privkey.pem;
    return 301 https://vecinity.mx$request_uri;
}
```

### ✅ **3. Servidor Principal (HTTPS non-www)**
```nginx
server {
    listen 443 ssl http2;
    server_name vecinity.mx;
    root /opt/docker/pagina_vecinity;
    # ... resto de configuración
}
```

### ✅ **4. Mejoras Adicionales:**
- **HTTP/2** habilitado
- **Security Headers** (HSTS, X-Frame-Options, etc.)
- **Gzip Compression** optimizada
- **Cache Control** para archivos estáticos (1 año)
- **Logs** separados

---

## 🛡️ Security Headers Incluidos

```nginx
# HSTS - Forzar HTTPS por 1 año
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload

# Prevenir clickjacking
X-Frame-Options: SAMEORIGIN

# Prevenir MIME sniffing
X-Content-Type-Options: nosniff

# XSS Protection
X-XSS-Protection: 1; mode=block

# Referrer Policy
Referrer-Policy: no-referrer-when-downgrade
```

---

## 📈 Performance Optimizations

### **1. HTTP/2**
- Conexiones más rápidas
- Multiplexing
- Server Push ready

### **2. Gzip Compression**
- Reduce tamaño de archivos ~70%
- Más rápido para usuarios

### **3. Cache Control**
```nginx
# Archivos estáticos: 1 año
location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

### **4. Access Log Off para archivos estáticos**
- Reduce carga del servidor
- Menos I/O en disco

---

## 🔧 Troubleshooting

### **Problema: "nginx: [emerg] cannot load certificate"**

**Solución:**
Verifica que los certificados existan:
```bash
sudo ls -la /etc/letsencrypt/live/vecinity.mx/
```

Si no existen, regenera con Certbot:
```bash
sudo certbot --nginx -d vecinity.mx -d www.vecinity.mx
```

---

### **Problema: "Connection refused"**

**Solución:**
Verifica que Nginx esté corriendo:
```bash
sudo systemctl status nginx
sudo systemctl start nginx
```

---

### **Problema: Redirects en loop infinito**

**Solución:**
Verifica que solo tengas UNA configuración activa:
```bash
ls -la /etc/nginx/sites-enabled/
```

Debe haber SOLO `vecinity.conf`, no duplicados.

---

### **Problema: 502 Bad Gateway**

**Solución:**
Revisa los logs:
```bash
sudo tail -f /var/log/nginx/vecinity-error.log
```

---

## 📝 Checklist Post-Instalación

Después de aplicar la nueva configuración:

- [ ] Backup del archivo anterior hecho
- [ ] Nueva configuración copiada
- [ ] `nginx -t` pasa sin errores
- [ ] Nginx recargado exitosamente
- [ ] Test 1: http://vecinity.mx → https://vecinity.mx ✅
- [ ] Test 2: http://www.vecinity.mx → https://vecinity.mx ✅
- [ ] Test 3: https://www.vecinity.mx → https://vecinity.mx ✅
- [ ] Test 4: https://vecinity.mx carga correctamente ✅
- [ ] Verificar en navegador que no hay errores SSL
- [ ] Verificar que el sitio carga completamente
- [ ] Revisar logs por errores

---

## 🌐 Verificación en Navegador

1. **Abre:** `http://vecinity.mx`
   - Debe redirigir a: `https://vecinity.mx` ✅

2. **Abre:** `http://www.vecinity.mx`
   - Debe redirigir a: `https://vecinity.mx` ✅

3. **Abre:** `https://www.vecinity.mx`
   - Debe redirigir a: `https://vecinity.mx` ✅

4. **Abre:** `https://vecinity.mx`
   - Debe cargar sin redirects ✅
   - Debe mostrar candado verde (SSL válido) ✅

---

## 🔍 Verificar en Google Search Console

Después de 24-48 horas:

1. Ve a: https://search.google.com/search-console
2. Verifica que solo indexe: `https://vecinity.mx`
3. Revisa que no haya errores de redirect
4. Actualiza el sitemap si es necesario

---

## 📊 Monitorear Rendimiento

Herramientas recomendadas:

1. **PageSpeed Insights:**
   https://pagespeed.web.dev/
   - Verifica: `https://vecinity.mx`

2. **SSL Labs:**
   https://www.ssllabs.com/ssltest/
   - Deberías obtener: **A o A+**

3. **Security Headers:**
   https://securityheaders.com/
   - Deberías obtener: **A o superior**

---

## 🎯 Resultado Esperado

Después de aplicar esta configuración:

✅ **SEO:**
- URL canónica: `https://vecinity.mx`
- Sin contenido duplicado
- Mejor ranking

✅ **Seguridad:**
- HTTPS forzado
- Security headers
- HSTS habilitado

✅ **Performance:**
- HTTP/2
- Gzip compression
- Cache optimizado
- A+ en SSL Labs

✅ **User Experience:**
- Redirects transparentes
- Carga rápida
- Sin errores

---

## 📞 Soporte

Si tienes algún problema:

1. Revisa los logs:
```bash
sudo tail -f /var/log/nginx/vecinity-error.log
```

2. Verifica la configuración:
```bash
sudo nginx -t
```

3. Restaura el backup si es necesario:
```bash
sudo cp /etc/nginx/sites-enabled/vecinity.conf.backup /etc/nginx/sites-enabled/vecinity.conf
sudo systemctl reload nginx
```

---

**🎉 ¡Configuración lista para producción!**

Desarrollado con ❤️ para Vecinity
© 2024 Vecinity. Todos los derechos reservados.
