#! /bin/sh
set -x
RUNTIME=${1:-rtpengine}

# Gradually fill the options of the command rtpengine which starts the RTPEngine daemon
# The variables used are sourced from the configuration file rtpengine-conf

if [ -z "$INTERFACES" ]; then

  # Discover public and private IP for this instance
  export PRIVATE_IPV4="$(curl --fail -qs http://169.254.169.254/2014-11-05/meta-data/local-ipv4)"   
  export PUBLIC_IPV4="$(curl --fail -qs http://169.254.169.254/2014-11-05/meta-data/public-ipv4)"

  INTERFACES="${PRIVATE_IPV4}!${PUBLIC_IPV4}"
fi

for interface in $INTERFACES; do
    OPTIONS="$OPTIONS --interface=$interface"
done

[ -z "$LISTEN_TCP" ] || OPTIONS="$OPTIONS --listen-tcp=$LISTEN_TCP"
[ -z "$LISTEN_UDP" ] || OPTIONS="$OPTIONS --listen-udp=$LISTEN_UDP"
[ -z "$LISTEN_NG" ] || OPTIONS="$OPTIONS --listen-ng=$LISTEN_NG"
[ -z "$LISTEN_CLI" ] || OPTIONS="$OPTIONS --listen-cli=$LISTEN_CLI"
[ -z "$TIMEOUT" ] || OPTIONS="$OPTIONS --timeout=$TIMEOUT"
[ -z "$SILENT_TIMEOUT" ] || OPTIONS="$OPTIONS --silent-timeout=$SILENT_TIMEOUT"
[ -z "$PIDFILE" ] || OPTIONS="$OPTIONS --pidfile=$PIDFILE"
[ -z "$TOS" ] || OPTIONS="$OPTIONS --tos=$TOS"
[ -z "$PORT_MIN" ] || OPTIONS="$OPTIONS --port-min=$PORT_MIN"
[ -z "$PORT_MAX" ] || OPTIONS="$OPTIONS --port-max=$PORT_MAX"
[ -z "$REDIS" ] || OPTIONS="$OPTIONS --redis=$REDIS"
[ -z "$REDIS_DB" ] || OPTIONS="$OPTIONS --redis-db=$REDIS_DB"
[ -z "$REDIS_READ" ] || OPTIONS="$OPTIONS --redis-read=$REDIS_READ"
[ -z "$REDIS_READ_DB" ] || OPTIONS="$OPTIONS --redis-read-db=$REDIS_READ_DB"
[ -z "$REDIS_WRITE" ] || OPTIONS="$OPTIONS --redis-write=$REDIS_WRITE"
[ -z "$REDIS_WRITE_DB" ] || OPTIONS="$OPTIONS --redis-write-db=$REDIS_WRITE_DB"
[ -z "$B2B_URL" ] || OPTIONS="$OPTIONS --b2b-url=$B2B_URL"
[ -z "$NO_FALLBACK" -o \( "$NO_FALLBACK" != "1" -a "$NO_FALLBACK" != "yes" \) ] || OPTIONS="$OPTIONS --no-fallback"
OPTIONS="$OPTIONS --table=$TABLE"
[ -z "$LOG_LEVEL" ] || OPTIONS="$OPTIONS --log-level=$LOG_LEVEL"
[ -z "$LOG_FACILITY" ] || OPTIONS="$OPTIONS --log-facility=$LOG_FACILITY"
[ -z "$LOG_FACILITY_CDR" ] || OPTIONS="$OPTIONS --log-facility-cdr=$LOG_FACILITY_CDR"
[ -z "$LOG_FACILITY_RTCP" ] || OPTIONS="$OPTIONS --log-facility-rtcp=$LOG_FACILITY_RTCP"
[ -z "$NUM_THREADS" ] || OPTIONS="$OPTIONS --num-threads=$NUM_THREADS"
[ -z "$DELETE_DELAY" ] || OPTIONS="$OPTIONS --delete-delay=$DELETE_DELAY"
[ -z "$GRAPHITE" ] || OPTIONS="$OPTIONS --graphite=$GRAPHITE"
[ -z "$GRAPHITE_INTERVAL" ] || OPTIONS="$OPTIONS --graphite-interval=$GRAPHITE_INTERVAL"
[ -z "$GRAPHITE_PREFIX" ] || OPTIONS="$OPTIONS --graphite-prefix=$GRAPHITE_PREFIX"
[ -z "$MAX_SESSIONS" ] || OPTIONS="$OPTIONS --max-sessions=$MAX_SESSIONS"

# Homer Options
[ -z "$HOMER_DEST" ] || OPTIONS="$OPTIONS --homer=${HOMER_DEST}"
[ -z "$HOMER_PROTOCOL" ] || OPTIONS="$OPTIONS --homer-protocol=udp"
[ -z "$HOMER_CAP_ID" ] || OPTIONS="$OPTIONS --homer-id=$HOMER_CAP_ID"

if test "$FORK" = "no" ; then
	OPTIONS="$OPTIONS --foreground"
fi

set +e
if [ -e /proc/rtpengine/control ]; then
	echo "del $TABLE" > /proc/rtpengine/control 2>/dev/null
fi

OPTIONS = "$OPTIONS --log-stderr"

set -x

exec $RUNTIME $OPTIONS
