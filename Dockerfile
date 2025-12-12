# Usamos una imagen específica y ligera (Alpine Linux)
FROM node:18-alpine

# Buenas prácticas: entorno de producción
ENV NODE_ENV=production

WORKDIR /app

# Copiamos primero el package.json (aprovechamos caché de capas de Docker)
COPY package.json package-lock.json* ./

# Instalamos solo dependencias de producción (menos superficie de ataque)
RUN npm ci --only=production && npm cache clean --force

# Copiamos el resto del código
COPY . .

# SEGURIDAD CRÍTICA: No correr como root
# La imagen oficial de Node trae un usuario llamado 'node'
USER node

EXPOSE 3000

CMD ["node", "src/app.js"]

