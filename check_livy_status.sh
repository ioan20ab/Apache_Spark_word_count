#!/bin/bash

# Path to Livy installation
LIVY_HOME=/path/to/livy

# Check if Livy log file exists
if [ ! -f $LIVY_HOME/logs/livy--server.out ]; then
    echo "Livy log file not found. Livy might not be started yet."
    exit 1
fi

# Print the last few lines of the log to check Livy server status
echo "Checking Livy server status..."
tail -n 10 $LIVY_HOME/logs/livy--server.out

# Check if Livy server is running via its REST API
LIVY_SERVER_URL="http://localhost:8998/sessions"
status_code=$(curl --write-out "%{http_code}" --silent --output /dev/null "$LIVY_SERVER_URL")

if [ "$status_code" -eq 200 ]; then
    echo "Livy server is running."
else
    echo "Livy server is not running. Status code: $status_code"
    exit 1
fi
