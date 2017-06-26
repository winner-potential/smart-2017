# Sender Component

Simple node.js application to send messages. This script will send x messages per second. Each message will have its own ID. Messages within one second will have the same value.

  node service.js [installationname] [endpointurl] [amountpersecond]
  node service.js test2 http://localhost:1880/endpoints/pvreceiver 100

Logging is placed into stdout.
