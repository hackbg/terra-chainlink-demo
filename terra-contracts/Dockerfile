FROM node:14 as builder
WORKDIR /home/node/app

COPY . .
RUN npm install

COPY . .


CMD ["npm", "start"]
