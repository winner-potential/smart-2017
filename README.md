Test setup for different solutions to integrate external systems, transform data, forward them to a database and aggregate information. This setup is implemented with Apache Camel, WS02CEP and Node-RED and utilizes concepts from EIP and CEP.

These files are required for reproduce the setup of the paper "Evaluation of Architectural Backbone Technologies for WINNER DataLab" on SMART 2017.

The setup includes the sender to produce traffic, three integration setups which receive, enrich, multicast and forward messages to the final receiver. Each setup will generate a simulated database message as well as a message as the result of a simple aggregation method (avg).

Requirements
------

- Docker at least 17.03.1-ce or better
- Docker-Compose at least 1.11.2 or better

*Note: It might be possible to run this with much older versions of Docker and Docker-Compose.*

Components
------

- **Sender** <br/>
  Simulates traffic and send packages to the configurated endpoint. Generates log with message id and timestamp. See sender/README.md for further details.
- **Receiver** <br/>
  Receives average and database messages. Generates log with message id, timestamp and received package. Reduce impreciseness for time measurements by using the same environment as the sender. See receiver/README.md for further details.
- **Node-RED**
  Handle messages with Node-RED. See nodered/README.md for further details.
- **NiFi**
  Handle messages with Apache NiFi. See nifi/README.md for further details.
- **Camel**
  Handle messages with Apache Camel. See camel/README.md for further details.
- **Maven**
  Deployment container with Maven. Used to build, package and deploy the Apache Camel setup into the Apache Camel container. See maven/README.md for further details.

Prepare Sender and Receiver
------
```
# Start sender and receiver
docker-compose -f senderreceiver.yml up -d
```
This command may executed on a different host than the testmachine.

Run Tests
------

First you have to modify the file ```run``` to suit your needs.
The first lines contain the following parameters:
```
export DELAY=60 #time in s before test
export DURATION=200 #time in s running the test
export WAIT_FOR_TERMINATION=460 #delay + duration * 2
```
You can set the ```DELAY``` the tool should wait before it sends a request to
the sender to start the measurement.
The ```DURATION``` value describes the time the sender transmits information.
The ```WAIT_FOR_TERMINATION``` value contains the complete runtime of the test,
including the waiting time for messages processed after the sending has ended.

You may reconfigure the test by changing the lower part of the run script:
```
run <YML file of tested tool> <AMOUNT OF MESSAGES PER SECOND>
```

The test run is started with the following call:
```
# Start test
./run <IP of sending machine> <IP of testmachine>
```
