# Estágio 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar arquivos de dependências
COPY package*.json ./

# Instalar dependências
RUN npm install

# Estágio 2: Runtime
FROM node:18-alpine

WORKDIR /app

# Copiar dependências do estágio anterior
COPY --from=builder /app/node_modules ./node_modules

# Copiar arquivos da aplicação
COPY . .

# Expor porta
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"

# Comando para iniciar a aplicação
CMD ["node", "app.js"]
