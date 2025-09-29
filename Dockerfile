FROM node:18-slim
WORKDIR /usr/src/app

# copiar dependências e instalar
COPY app/package*.json ./
RUN npm install --production

# copiar código
COPY app/ .

EXPOSE 3000
CMD ["node", "server.js"]
