FROM openjdk:8-jre-slim
LABEL maintainer="Asanka Vithanage"
ARG JMETER_VERSION

ENV JMETER_VERSION ${JMETER_VERSION:-5.1.1}
ENV CMDRUNNER_VERSION 2.2
ENV PLUGINMGR_VERSION 1.3
ENV JMETER_HOME /jmeter/apache-jmeter-$JMETER_VERSION/
ENV PATH $JMETER_HOME/bin:$PATH

# INSTALL PRE-REQ
RUN apt-get update && \
    apt-get -y install \
    curl

# INSTALL JMETER BASE
RUN mkdir /jmeter
WORKDIR /jmeter

RUN curl -O https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz  \
      && tar -xzf apache-jmeter-$JMETER_VERSION.tgz  \
      && rm apache-jmeter-$JMETER_VERSION.tgz  \
      && rm -rf apache-jmeter-$JMETER_VERSION/docs apache-jmeter-$JMETER_VERSION/printable_docs \
      && cd $JMETER_HOME/lib \
      && curl -O https://repo1.maven.org/maven2/kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar \
      && cd $JMETER_HOME/lib/ext \
      && curl -O https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/$PLUGINMGR_VERSION/jmeter-plugins-manager-$PLUGINMGR_VERSION.jar \
      && java -cp jmeter-plugins-manager-$PLUGINMGR_VERSION.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
      && cd $JMETER_HOME/bin \
      && sh PluginsManagerCMD.sh install-all-except jpgc-hadoop,jpgc-oauth \
      && sleep 2 \
      && sh PluginsManagerCMD.sh status

WORKDIR $JMETER_HOME

COPY config/user.properties bin/user.properties
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

EXPOSE 1099 50000
ENTRYPOINT ["/docker-entrypoint.sh"]