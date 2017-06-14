FROM wildflyext/wildfly-camel:4.6.0

USER root
COPY start cpu mem /opt/jboss/
RUN chmod +x /opt/jboss/start /opt/jboss/cpu /opt/jboss/mem

RUN mkdir -p /measurements && chown -R jboss:jboss /measurements
VOLUME ["/measurements"]

USER jboss

ENTRYPOINT /opt/jboss/start
