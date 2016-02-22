#!/bin/bash
DRILL_ALIAS="my-drill"
DRILL_TAG="latest"

cdir="`dirname "$0"`"
cdir="`cd "$cdir"; pwd`"

[[ "$TRACE" ]] && set -x

_log() {
  [[ "$2" ]] && echo "[`date +'%Y-%m-%d %H:%M:%S.%N'`] - $1 - $2"
}

info() {
  [[ "$1" ]] && _log "INFO" "$1"
}

warn() {
  [[ "$1" ]] && _log "WARN" "$1"
}

setup_env() {
  info "Load environment variables from $cdir/drill-cluster-env.sh..."
  if [ -f $cdir/drill-cluster-env.sh ]
  then
    . "$cdir/drill-cluster-env.sh"
  else
    warn "Skip drill-cluster-env.sh as it does not exist"
  fi

  # check environment variables and set defaults as required
  : ${CLUSTER_ID:="$DRILL_ALIAS"}
  : ${ZOOKEEPER:="localhost"}
  : ${LOG_DIR:="$cdir/drill-log"}

  mkdir -p $CONF_DIR $DATA_DIR $LOG_DIR

  info "Loaded environment variables:"
  info "        CLUSTER_ID = $CLUSTER_ID"
  info "        ZOOKEEPER  = $ZOOKEEPER"
  info "        LOG_DIR    = $LOG_DIR" 
}

start_drill() {
  info "Stop and remove \"$DRILL_ALIAS\" if it exists and start new one"
  # stop and remove the container if it exists
  docker stop "$DRILL_ALIAS" >/dev/null 2>&1 && docker rm "$DRILL_ALIAS" >/dev/null 2>&1

  # use --privileged=true has the potential risk of causing clock drift
  # references: http://stackoverflow.com/questions/24288616/permission-denied-on-accessing-host-directory-in-docker
  docker run -d --name="$DRILL_ALIAS" --net=host --restart=always \
    -e CLUSTER_ID="$CLUSTER_ID" -e ZOOKEEPER="$ZOOKEEPER" -v $LOG_DIR:/apache-drill/log:Z \
    zhicwu/drill:$DRILL_TAG

  info "Try 'docker logs -f \"$DRILL_ALIAS\"' or check logs under $LOG_DIR to see if this works"
}

main() {
  setup_env
  start_drill
}

main "$@"
