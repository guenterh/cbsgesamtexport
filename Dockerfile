FROM ubuntu:18.04 as prepare

RUN  apt-get update \
  && apt-get install -y wget less tar git openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/metafacture/metafacture-core/releases/download/metafacture-core-5.0.1/metafacture-core-5.0.1-dist.tar.gz
RUN tar xfz  metafacture-core-5.0.1-dist.tar.gz
RUN git clone https://gitlab.com/swissbib/linked/swissbib-metafacture-commands.git
RUN cd swissbib-metafacture-commands && git checkout clone-develop && ./gradlew shadowJar --refresh-dependencies -x test


FROM openjdk:8-jre-alpine

RUN apk update
RUN apk upgrade
RUN apk add bash

#see https://github.com/docker-library/openjdk/issues/289
RUN apk add --no-cache nss

WORKDIR app

COPY --from=prepare metafacture-core-5.0.1-dist /app
COPY --from=prepare swissbib-metafacture-commands/metafacture-kafka/build/libs  /app/plugins
COPY --from=prepare swissbib-metafacture-commands/metafacture-io/build/libs  /app/plugins
COPY --from=prepare swissbib-metafacture-commands/metafacture-mangling/build/libs  /app/plugins
COPY --from=prepare swissbib-metafacture-commands/metafacture-biblio/build/libs  /app/plugins

RUN rm /app/plugins/README.md

COPY cbsadapter.flux .
COPY java-options.conf /app/config

ENTRYPOINT ["/app/flux.sh"]

CMD ["cbsadapter.flux"]

#start des container: docker container run -it -d --rm   gesamtexport


