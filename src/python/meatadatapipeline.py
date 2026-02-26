from pyspark.sql import SparkSession

#Plain pyspark
spark = SparkSession.builder \
    .appName("MetadataDrivenNestedLoop") \
    .getOrCreate()

# Metadata: tables and their columns
metadata = [
    {"source": "raw.customers", "target": "silver.customers", "columns": ["id", "name", "email"]},
    {"source": "raw.orders", "target": "silver.orders", "columns": ["order_id", "customer_id", "amount"]},
    {"source": "raw.products", "target": "silver.products", "columns": ["product_id", "sku", "price"]}
]

for table in metadata:  # Outer loop -> tables
    print(f"\n Processing {table['source']} --> {table['target']}")
    df=spark.table(table['source'])

    selected_cols = []
    for col in table['columns']:    # Inner loop -> columns
        print(f"    Selecting: {col}")
        selected_cols.append(col)

    df.select(*selected_cols)\
        .write.format("delta")\
        .mode("overwrite")\
        .saveAsTable(table["target"])