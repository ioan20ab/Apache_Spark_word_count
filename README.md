# Apache_Spark_word_count
Automated Spark word count Job Submission and Monitoring Using Livy

Created a simple flexible shell script to submit Spark jobs to a Livy server using the Livy REST API, supporting various job types (PySpark, JAR files).
Integrated a polling mechanism to monitor job progress in real-time, automatically checking for success, failure, or error states.
Automate retrieval of Spark job logs via the Livy API and formatted logs for easier debugging and performance tracking using jq for structured log parsing.
