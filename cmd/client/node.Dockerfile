FROM node:14.16-alpine3.12

WORKDIR /app
COPY . .
CMD ["node", "get.js"]

