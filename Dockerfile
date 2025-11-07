# Dockerfile para Vecinity Landing Page
FROM nginx:alpine

# Metadata
LABEL maintainer="Vecinity <contacto@vecinity.mx>"
LABEL description="Landing page de Vecinity"
LABEL version="1.0"

# Instalar dependencias adicionales (opcional)
RUN apk add --no-cache \
    bash \
    curl \
    tzdata

# Configurar zona horaria
ENV TZ=America/Mexico_City
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copiar archivos de la landing page
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/
COPY script.js /usr/share/nginx/html/
COPY assets /usr/share/nginx/html/assets

# Copiar configuración de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Crear directorio para logs
RUN mkdir -p /var/log/nginx

# Permisos
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Exponer puertos
EXPOSE 80 443

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost || exit 1

# Comando de inicio
CMD ["nginx", "-g", "daemon off;"]
