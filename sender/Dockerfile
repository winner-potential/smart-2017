FROM node:6

RUN mkdir -p /usr/src/sender
COPY service.js package.json start /usr/src/sender/

# Add sender user so we aren't running as root.
RUN useradd --home-dir /usr/src/sender --no-create-home sender \
    && chown -R sender:sender /usr/src/sender && chmod +x /usr/src/sender/start

RUN mkdir -p /measurements && chown -R sender:sender /measurements
VOLUME ["/measurements"]

WORKDIR /usr/src/sender

USER sender

RUN npm install

CMD ["./start"]
