Test setup for different solutions to integrate external systems, transform data, forward them to a database and aggregate information. This setup is implemented with Apache Camel, WS02CEP and Node-RED and utilizes concepts from EIP and CEP.

These files are required for reproduce the setup of the paper "Evaluation of Architectural Backbone Technologies for WINNER DataLab" on SMART 2017.

The setup includes the sender to produce traffic, three integration setups which receive, enrich, multicast and forward messages to the final receiver. Each setup will generate a simulated database message as well as a message as the result of a simple aggregation method (avg).

Requirements
------

- Docker at least 17.03.1-ce or better
- Docker-Compose at least 1.11.2 or better
- JDK 1.7 (7u80) from [Orcale]( http://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase7-521261.html) (only for WSO2 Test)
- WSO2CEP 4.2.0 from [WSO2](http://wso2.com/products/complex-event-processor/) (only for WSO2 Test)

*Note: It might be possible to run this with much older versions of Docker and Docker-Compose.*

Components
------

- **Sender** <br/>
  Simulates traffic and send packages to the configurated endpoint. Generates log with message id and timestamp. See sender/README.md for further details.
- **Receiver** <br/>
  Receives average and database messages. Generates log with message id, timestamp and received package. Reduce impreciseness for time measurements by using the same environment as the sender. See receiver/README.md for further details.
- **WSO2**
  Handle messages with WSO2CEP. This component requires to download a specific JDK and the environment itself. See wso2/README.md for further details.
- **Node-RED**
  Handle messages with Node-RED. See nodered/README.md for further details.
- **Camel**
  Handle messages with Apache Camel. See camel/README.md for further details.
- **Maven**
  Deployment container with Maven. Used to build, package and deploy the Apache Camel setup into the Apache Camel container. See maven/README.md for further details.

Run Node-RED Test
------

*Note: This runs everything on one single node. For final results the "noderedtest" service should be separated.*

```
# Start test
docker-compose -f docker-compose-nodered.yml up -d
# Wait as long as you want to measure, e. g., 10 Minutes
docker-compose -f docker-compose-nodered.yml stop
# Copy all measurements to data/<timestamp>/...
./getdata
# Remove test stuff
docker-compose -f docker-compose-nodered.yml down -v
```

Run WSO2CEP Test
------

*Note: This runs everything on one single node. For final results the "wso2test" service should be separated.*

*Important: This component requires to download a specific JDK and the environment itself. See wso2/README.md for further details.*

```
# Start test
docker-compose -f docker-compose-wso2.yml up -d
# Wait as long as you want to measure, e. g., 10 Minutes
docker-compose -f docker-compose-wso2.yml stop
# Copy all measurements to data/<timestamp>/...
./getdata
# Remove test stuff
docker-compose -f docker-compose-wso2.yml down -v
```

Run Apache Camel Test
------

*Note: This runs everything on one single node. For final results the "cameltest" service should be separated.*

```
# Start test
docker-compose -f docker-compose-camel.yml up -d
# Wait as long as you want to measure, e. g., 10 Minutes
docker-compose -f docker-compose-camel.yml stop
# Copy all measurements to data/<timestamp>/...
./getdata
# Remove test stuff
docker-compose -f docker-compose-camel.yml down -v
```
