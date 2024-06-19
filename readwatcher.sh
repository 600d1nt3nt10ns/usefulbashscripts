#!/bin/bash
# Monitor file for changes
# usage: readwatcher.sh (file)
if [ -z "$1" ]; then
        echo "Usage: readwatcher.sh (file)"
        exit 1
fi
# if the file exists
if [ -f "$1" ] || [ -d "$1" ]; then
        # Checking if this file or directory is being monitored.
        if [ "$(ps aux | grep inotifywait | grep -c "$1")" -gt "0" ]; then
                echo "The file or directory is being monitored already: "
                ps aux | grep inotifywait | grep "$1"
                exit 1
        fi
        echo "Monitoring $1 started at $(date +%Y%m%d%H%M%S)"
                inotifywait -m -r -e access "$1" | while read -r FILE
                do
                        #echo "An read event has been detected in $FILE at $(date +%Y%m%d%H%M%S)"
                        echo "An read event has been detected in $FILE at $(date +%Y%m%d%H%M%S)" | sendmail root
        done
else
        echo "File or directory $1 not found."
        exit 1
fi
