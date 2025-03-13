#bring image

FROM node:20-alpine AS build

#working directory in the container

WORKDIR /app

#Copy json file to install npm

COPY package*.json ./

#Build the dependecies

RUN npm ci

COPY . .

#Building dependencies

RUN npm run build

#stage 2

FROM gcr.io/distroless/nodejs20-debian12

WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
EXPOSE 3000
CMD ["./node_modules/.bin/serve", "-s", "dist", "-l", "3000"]

