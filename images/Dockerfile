FROM centos

MAINTAINER "luobo"
COPY elmmb /etc/elm/elmmb
COPY Config.json /etc/elm/Config.json
WORKDIR /etc/elm

EXPOSE 3000
RUN chmod 777 /etc/elm/elmmb

ENTRYPOINT ["./elmmb"]
