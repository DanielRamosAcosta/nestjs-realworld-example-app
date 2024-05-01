FROM node:lts-alpine as builder

WORKDIR /app
ADD ./package.json ./package.json
ADD ./package-lock.json ./package-lock.json
RUN npm ci

COPY . .

RUN npm run build

RUN npm install --omit=dev

FROM node:lts-alpine

WORKDIR /app

ENV NODE_ENV production

COPY --from=builder ./app/node_modules ./node_modules
COPY --from=builder ./app/dist ./dist

EXPOSE 8080

CMD node ./dist/main.js
