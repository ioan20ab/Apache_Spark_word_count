#!/usr/bin/env python
# coding: utf-8

# In[ ]:


from pyspark.sql import SparkSession

# Initialize Spark Session
spark = SparkSession.builder.appName("Simple Word Count").getOrCreate()


# In[ ]:


# Load text file into an RDD
text_file = spark.read.text("/path/to/your/file.txt").rdd


# In[ ]:


# Split lines into words
words = text_file.flatMap(lambda line: line[0].split(" "))


# In[ ]:


# Map each word to (word, 1) and count occurrences
word_counts = words.map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)


# In[ ]:


# Collect and print results
output = word_counts.collect()
for (word, count) in output:
    print(f"{word}: {count}")

spark.stop()

