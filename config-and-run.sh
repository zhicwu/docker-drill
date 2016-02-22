#!/bin/bash
# shamelessly copied from https://github.com/wurstmeister/drill-docker/blob/master/start-drill.sh

if [ ! -f $DRILL_HOME/conf/drill-override.conf ]; then
  cp $DRILL_HOME/conf/drill-override-example.conf $DRILL_HOME/conf/drill-override.conf
fi

sed -r -i "s/(zk.connect):(.*)/\1: \"$ZOOKEEPER\"/g" /$DRILL_HOME/conf/drill-override.conf
sed -r -i "s/(cluster-id):(.*)/\1: \"$CLUSTER_ID\"/g" /$DRILL_HOME/conf/drill-override.conf

./bin/drillbit.sh start
