# syntax=docker/dockerfile:1

FROM node:18-alpine AS build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY src ./src
COPY spec ./spec

FROM node:18-alpine
WORKDIR /app
COPY --from=build /app /app

CMD ["node", "src/index.js"]
EXPOSE 3000
