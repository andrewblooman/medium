#  Container used to build the minified frontend JS code
FROM node:buster AS frontend-builder

RUN apt update && apt install git

RUN git clone https://github.com/yeti-platform/yeti-feeds-frontend.git /app
WORKDIR /app

RUN npm install
RUN npm run build

FROM nginx:latest AS frontend
COPY --from=frontend-builder /app/dist /www
EXPOSE 80
