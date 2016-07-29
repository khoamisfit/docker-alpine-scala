FROM misfit/ops_oracle_jdk8:latest

ENV SCALA_VERSION=2.11.6 \
    SCALA_HOME=/usr/share/scala \
    SBT_HOME=/usr/share/sbt \
    SBT_VERSION=0.13.8 

# NOTE: bash is used by scala/scalac scripts, and it cannot be easily replaced with ash.

RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    apk add --no-cache bash git openssh && \
    cd "/tmp" && \
    wget "https://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz" && \
    tar xzf "scala-${SCALA_VERSION}.tgz" && \
    mkdir "${SCALA_HOME}" && \
    rm "/tmp/scala-${SCALA_VERSION}/bin/"*.bat && \
    mv "/tmp/scala-${SCALA_VERSION}/bin" "/tmp/scala-${SCALA_VERSION}/lib" "${SCALA_HOME}" && \
    ln -s "${SCALA_HOME}/bin/"* "/usr/bin/" && \
    rm -rf "/tmp/"*
ADD sbt ${SBT_HOME}/sbt
RUN cd "${SBT_HOME}" && \
    wget "https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar" && \
    ln -s "${SBT_HOME}/sbt" "/usr/bin" && \
    apk del .build-dependencies
