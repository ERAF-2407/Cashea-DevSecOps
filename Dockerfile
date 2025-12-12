FROM node:18-alpine

# Buenas prácticas OWASP: Minimizar superficie de ataque
WORKDIR /app
COPY src/package.json .
RUN npm install --only=production

COPY src/ .

# OWASP Docker Top 10: No correr como root
USER node 

EXPOSE 3000
CMD ["node", "app.js"]