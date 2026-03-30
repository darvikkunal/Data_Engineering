import argparse
import sys
from pyspark.sql import SparkSession

try:
    from awsglue.context import GlueContext
    from awsglue.job import Job
    glue_available = True
except Exception:
    glue_available = False


def main(job_name: str):
    spark = SparkSession.builder.appName("local_glue_job").getOrCreate()

    use_glue = glue_available
    if use_glue:
        try:
            sc = spark.sparkContext
            glueContext = GlueContext(sc)
            job = Job(glueContext)
            job.init(job_name, {})
        except Exception as e:
            print("awsglue GlueContext not available on JVM classpath, falling back to plain Spark:", e)
            use_glue = False

    # read a CSV from the repo `data/` folder
    df = spark.read.option("header", "true").csv("data/customers.csv")
    print(f"Read {df.count()} rows")
    df.show(10, truncate=False)

    if 'use_glue' in locals() and use_glue:
        job.commit()

    spark.stop()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--JOB_NAME", default="local_test")
    parsed, _ = parser.parse_known_args()
    main(parsed.JOB_NAME)
