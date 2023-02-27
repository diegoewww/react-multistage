# Primera etapa - compilar la aplicación
FROM node:14-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build 

# Segunda etapa - empaquetar la aplicación
FROM node:14-alpine
WORKDIR /app
COPY --from=build /app/build .
RUN tar -czf app.tar.gz .

# Tercera etapa - crear la imagen final con el archivo tar
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=1 /app/app.tar.gz .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]