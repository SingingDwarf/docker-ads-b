#!/bin/sh

set -o errexit          # Exit on most errors (see the manual)
#set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
#set -o pipefail         # Use last non-zero exit code in a pipeline
set -o xtrace          # Trace the execution of the script (debug)

DUMP1090_SERVER='dump1090'
DUMP1090_PORT='30005'

echo "Waiting for dump1090 to start up"
sleep 5s

echo "Ping test to dump1090"
ping -c 3 "${DUMP1090_SERVER}"

echo "Read ADSBEXCHANGE_PORT=${ADSBEXCHANGE_PORT}"

while true; do
  echo "Starting replay from TCP:${DUMP1090_SERVER}:${DUMP1090_PORT} to TCP:feed.adsbexchange.com:${ADSBEXCHANGE_PORT}"
  
  set +o errexit
  socat -u "TCP:${DUMP1090_SERVER}:${DUMP1090_PORT}" "TCP:feed.adsbexchange.com:${ADSBEXCHANGE_PORT}"
  SOCAT_STATUS=${?}
  set -o errexit
  
  echo "Replay ended"

  if [[ "${SOCAT_STATUS}" -eq 0 ]]; then
    echo "Replay ended without failure"
    break
  else
    echo "Replay ended with failure (${SOCAT_STATUS}) - restarting"
  fi
done

exit ${SOCAT_STATUS}
