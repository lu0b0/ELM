FROM alpine

MAINTAINER "luobo"
COPY elmmb /etc/elm/elmmb
COPY Config.json /etc/elm/Config.json
WORKDIR /etc/elm

EXPOSE 3000
RUN chmod a+xr -R /etc/elm

ENTRYPOINT ["./elmmb"]