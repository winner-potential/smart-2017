FROM node:6

# Home directory for Node-RED application source code.
RUN mkdir -p /usr/src/node-red/node_modules

# User data directory, contains flows, config and nodes.
RUN mkdir /data

COPY node-red-node-process /usr/src/node-red-node-process

RUN cd /usr/src/node-red-node-process && npm install && npm link

WORKDIR /usr/src/node-red

# Add node-red user so we aren't running as root.
RUN useradd --home-dir /usr/src/node-red --no-create-home node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red

COPY start cpu /usr/src/node-red/
RUN chmod +x cpu && chmod +x start
RUN mkdir -p /measurements && chown -R node-red:node-red /measurements
VOLUME ["/measurements"]

USER node-red

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
RUN npm install && npm link node-red-node-process

# User configuration directory volume
EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json

COPY settings.js /data/
COPY flows.json /data/

CMD ["./start"]
