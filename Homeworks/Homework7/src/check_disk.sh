#!/bin/bash

LIMIT=${1:-10}
LOGFILE="/var/log/disk.log"

/bin/df / | /usr/bin/awk 'NR==2 {print $5}' | /bin/sed 's/%//' | {
    read USAGE
    if [ "$USAGE" -gt "$LIMIT" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') WARNING: / usage is at ${USAGE}% (limit: ${LIMIT}%)" >> "$LOGFILE"
    fi
}

