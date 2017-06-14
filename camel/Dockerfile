FROM wildflyext/wildfly-camel:4.6.0

USER root
COPY start cpu /opt/jboss/
RUN chmod +x /opt/jboss/start /opt/jboss/cpu

RUN mkdir -p /measurements && chown -R jboss:jboss /measurements
VOLUME ["/measurements"]

USER jboss

ENTRYPOINT /opt/jboss/start
