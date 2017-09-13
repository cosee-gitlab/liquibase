FROM java:8-jre

ENV LIQUIBASE_VERSION 3.5.3
ENV MYSQL_CONNECTOR_VERSION 5.1.44

RUN apt-get update && apt-get install -y \
    unzip \
    curl  \
    && rm -rf /var/lib/apt/lists/*

RUN \
  curl -sf -o liquibase-bin.zip -L https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}-bin.zip && \
  mkdir -p /opt/liquibase && \
  unzip liquibase-bin.zip -d /opt/liquibase && \
  rm -f liquibase-bin.zip && \
  chmod +x /opt/liquibase/liquibase && \
  ln -s /opt/liquibase/liquibase /bin/

RUN \
  curl -sfL -o mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.zip http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.zip && \
  mkdir /opt/jdbc_drivers/ && \
  unzip mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.zip -d /opt/jdbc_drivers/ && \
  chmod +x /opt/jdbc_drivers/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}-bin.jar && \
  ln -s /opt/jdbc_drivers/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}-bin.jar /opt/liquibase/lib/

VOLUME ["/changelogs"]

WORKDIR /changelogs

ENV LIQUIBASE_HOME /opt/liquibase

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]