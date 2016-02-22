#
# This docker image is just for development and testing purpose - please do NOT use on production
#

# Pull Base Image
FROM zhicwu/java:7

# Set Maintainer Details
MAINTAINER Zhichun Wu <zhicwu@gmail.com>

# Set Environment Variables
ENV DRILL_VERSION=1.5.0 DRILL_HOME=/apache-drill \
	APACHE_BASE_URL=http://www.apache.org/dyn/closer.lua?action=download&filename= \
	MYSQL_DRIVER_VERSION=5.1.38 PRESTO_DRIVER_VERSION=0.138 JTDS_VERSION=1.3.1

# Set labels
LABEL drill_version="Apache Drill $DRILL_VERSION" 

# Install Apache Drill
RUN wget ${APACHE_BASE_URL}/drill/drill-${DRILL_VERSION}/apache-drill-${DRILL_VERSION}.tar.gz \
		http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar \
		https://repo1.maven.org/maven2/com/facebook/presto/presto-jdbc/${PRESTO_DRIVER_VERSION}/presto-jdbc-${PRESTO_DRIVER_VERSION}.jar \
		http://central.maven.org/maven2/net/sourceforge/jtds/jtds/${JTDS_VERSION}/jtds-${JTDS_VERSION}.jar \
	&& tar zxvf *.tar.gz \
	&& rm -f *.tar.gz \
	&& ln -s apache-drill-${DRILL_VERSION} ${DRILL_HOME} \
	&& cd ${DRILL_HOME} \
	&& cd -

WORKDIR $DRILL_HOME

COPY config-and-run.sh ./bin/

RUN chmod +x ./bin/*.sh

EXPOSE 8047

VOLUME ["$DRILL_HOME/log"]

CMD ["./bin/config-and-run.sh"]
