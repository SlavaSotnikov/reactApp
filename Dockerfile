# FROM node:18 AS build
# WORKDIR /app

# COPY package*.json ./
# RUN npm install

# COPY . .
# RUN npm run build

# FROM nginx:alpine
# COPY --from=build /app/build /usr/share/nginx/html

#################### 1. BUILD stage ####################
FROM node:18-alpine AS build
WORKDIR /app

# ① lock-файли: reproducible build
COPY package*.json ./
RUN npm ci --ignore-scripts   # швидше й детерміновано

# ② копіюємо код + .env (з контексту)
COPY . .

# ③ збірка. CRA/Vite читає REACT_APP_* із .env або ARG
ARG REACT_APP_BASE_URL
ENV REACT_APP_BASE_URL=$REACT_APP_BASE_URL
RUN npm run build

#################### 2. RUNTIME stage ###################
FROM nginx:1.25-alpine

# ④ власний конфіг із проксі
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ⑤ статичні файли
COPY --from=build /app/build /usr/share/nginx/html

