FROM centos

MAINTAINER "luobo"
COPY radish /etc/lb/radish
COPY Config.json /etc/lb/Config.json
WORKDIR /etc/lb

EXPOSE 3001
RUN chmod 777 /etc/lb/radish

ENTRYPOINT ["./radish"]