#!/bin/bash

# Path to Livy installation
LIVY_HOME=/path/to/livy

# Start Livy server
echo "Starting Livy server..."
$LIVY_HOME/bin/livy-server start

# Check if Livy started successfully
if [ $? -eq 0 ]; then
    echo "Livy server started successfully."
else
    echo "Failed to start Livy server."
    exit 1
fi

# Print the Livy server log to ensure it's running
tail -f $LIVY_HOME/logs/livy--server.out
