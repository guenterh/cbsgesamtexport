FROM ubuntu:18.04 as prepare

RUN  apt-get update \
  && apt-get install -y wget less tar git openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/metafacture/metafacture-core/releases/download/metafacture-core-5.0.1/metafacture-core-5.0.1-dist.tar.gz
RUN tar xfz  metafacture-core-5.0.1-dist.tar.gz
RUN git clone https://gitlab.com/swissbib/linked/swissbib-metafacture-commands.git
RUN cd swissbib-metafacture-commands && git checkout clone-develop && ./gradlew clean shadowJar --refresh-dependencies -x test


FROM openjdk:8-jre-alpine

RUN apk update
RUN apk upgrade
RUN apk add bash

#see https://github.com/docker-library/openjdk/issues/289
RUN apk add --no-cache nss

WORKDIR app
VOLUME /data

COPY --from=prepare metafacture-core-5.0.1-dist /app
COPY --from=prepare swissbib-metafacture-commands/metafacture-kafka/build/libs  /app/plugins
COPY --from=prepare swissbib-metafacture-commands/metafacture-io/build/libs  /app/plugins
COPY --from=prepare swissbib-metafacture-commands/metafacture-mangling/build/libs  /app/plugins
COPY --from=prepare swissbib-metafacture-commands/metafacture-biblio/build/libs  /app/plugins

RUN rm /app/plugins/README.md

COPY cbsadapter.flux  .
COPY cbsadapter_files.flux .
COPY java-options.conf /app/config

ENTRYPOINT ["/app/flux.sh"]

CMD ["cbsadapter.flux"]

#Benutzte Kommandos
#start des container: docker container run -it -d --rm   gesamtexport

#Aufruf innerhaöb des Container
#docker container run --rm  -it --entrypoint /bin/bash  -v /swissbib_index/apps/cbs/data:/data gesamtexport

#als daemon
#docker run -d --rm -v /swissbib_index/apps/cbs/data:/data gesamtexport cbsadapter_files.flux




