#!/bin/sh

set -e

nginx -g 'pid /tmp/nginx.pid;' -c '/nginx.conf'
mkdir -p '/run/dump1090'
/usr/local/bin/dump1090 --quiet --net --net-bind-address 0.0.0.0 --write-json '/run/dump1090' --debug n --mlat --net-heartbeat 5 --stats-every 60
