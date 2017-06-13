FROM node:6

RUN mkdir -p /usr/src/sender

WORKDIR /usr/src/sender

COPY service.js /usr/src/sender/
COPY package.json /usr/src/sender/
COPY start /usr/src/sender/
RUN npm install && chmod +x start

CMD ["./start"]
