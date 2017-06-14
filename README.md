Test setup for different solutions to integrate external systems, transform data, forward them to a database and aggregate information. This setup is implemented with Apache Camel, WS02CEP and Node-RED and utilizes concepts from EIP and CEP.

These files are required for reproduce the setup of a paper on SMART 2017.

Run Node-RED Test
------

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
