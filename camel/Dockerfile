FROM wildflyext/wildfly-camel:4.6.0

USER root
COPY start cpu /opt/jboss/
RUN chmod +x /opt/jboss/start /opt/jboss/cpu
USER jboss

ENTRYPOINT /opt/jboss/start
