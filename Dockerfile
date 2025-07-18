FROM node:20.19.4 AS deps

WORKDIR /usr/src/app

COPY package.json ./
COPY package-lock.json ./

RUN ls

RUN npm ci --no-audit --no-progress

FROM node:20.19.4 AS build

WORKDIR /usr/src/app

COPY --from=deps /usr/src/app/node_modules ./node_modules

COPY . .

RUN npm run build

FROM node:20.19.4-slim

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

CMD ["npm", "run", "start"]
