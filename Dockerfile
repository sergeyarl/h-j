FROM node:latest
MAINTAINER s.arlashin@gmail.com
WORKDIR /usr/src

COPY package.json /usr/src/package.json

RUN npm install

COPY app.js /usr/src/
COPY test /usr/src/test
COPY script /usr/src/script

USER nobody

EXPOSE 5000
CMD ["node", "app.js"]
