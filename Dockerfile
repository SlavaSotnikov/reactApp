# FROM node:18 AS build
# WORKDIR /app

# COPY package*.json ./
# RUN npm install

# COPY . .
# RUN npm run build

# FROM nginx:alpine
# COPY --from=build /app/build /usr/share/nginx/html

####################  Build stage  ####################
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN npm run build

####################  Runtime stage ###################
FROM nginx:1.25-alpine
# — видалимо стандартний default.conf
RUN rm /etc/nginx/conf.d/default.conf
# — копіюємо наш власний конфіг
COPY nginx.conf /etc/nginx/conf.d/default.conf
# — статичні файли React
COPY --from=build /app/build /usr/share/nginx/html
