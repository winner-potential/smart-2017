FROM alpine:3.7

COPY start /root/
RUN apk update && apk add ca-certificates wget && chmod +x /root/start

WORKDIR /root
ENTRYPOINT [ "/bin/sh" ]
CMD ["/root/start"]