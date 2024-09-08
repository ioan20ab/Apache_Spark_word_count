#!/bin/bash

# Check if the Spark job file is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: ./submit_spark_job_enhanced.sh <path_to_spark_job_file>"
    exit 1
fi

SPARK_JOB_FILE=$1

# Livy server URL
LIVY_SERVER_URL="http://localhost:8998"

# Function to check job status
check_job_status() {
    local batch_id=$1
    local status_response=$(curl -s -X GET "$LIVY_SERVER_URL/batches/$batch_id")
    local state=$(echo "$status_response" | grep -o '"state":"[a-zA-Z]*"' | cut -d: -f2 | tr -d '"')
    echo $state
}

# Submit Spark job to Livy
echo "Submitting Spark job to Livy server..."

response=$(curl -s -X POST --data "{\"file\": \"$SPARK_JOB_FILE\"}" \
    -H "Content-Type: application/json" \
    "$LIVY_SERVER_URL/batches")

# Extract batch ID from the response
batch_id=$(echo "$response" | grep -o '"id":[0-9]*' | cut -d: -f2)

if [ -z "$batch_id" ]; then
    echo "Failed to submit Spark job."
    exit 1
else
    echo "Spark job submitted successfully. Batch ID: $batch_id"
fi

# Polling the job status until it is finished
echo "Monitoring job status..."
while true; do
    status=$(check_job_status "$batch_id")

    # Output current status
    echo "Current status: $status"

    # Break the loop if job is in a finished state
    if [ "$status" == "success" ] || [ "$status" == "dead" ] || [ "$status" == "error" ]; then
        echo "Job finished with status: $status"
        break
    fi

    # Wait for a few seconds before checking again
    sleep 10
done

# Fetch and display job logs
echo "Fetching job logs..."
curl -s "$LIVY_SERVER_URL/batches/$batch_id/log" | jq '.log'
