# Estágio 1: Build da aplicação
FROM node:22-alpine AS build

WORKDIR /app

# Copia arquivos de dependências
COPY package*.json ./

# Instala dependências
RUN npm ci

# Copia o código fonte
COPY . .

# Build de produção
RUN npm run build -- --configuration production

# Estágio 2: Servidor Nginx
FROM nginx:alpine

# Copia os arquivos buildados
COPY --from=build /app/dist/devops-pucrs-ana-cagliari/browser /usr/share/nginx/html

# Copia configuração customizada do nginx (opcional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80
EXPOSE 80

# Comando padrão do nginx
CMD ["nginx", "-g", "daemon off;"]
