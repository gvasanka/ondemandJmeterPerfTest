#!/bin/bash
set -e

case $1 in
    master)
        tail -f /dev/null
        ;;
    server)
        $JMETER_HOME/bin/jmeter-server \
            -Dserver.rmi.localport=1099 \
            -Dserver_port=1099 \
            -Jserver.rmi.ssl.disable=true
        ;;
    *)
        echo "Sorry, this option doesn't exist!"
        ;;
esac

exec "$@"
