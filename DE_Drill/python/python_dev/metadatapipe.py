metadata = [
    {"source": "raw.customers", "target": "silver.customers", "columns": ["id", "name", "email"]},
    {"source": "raw.orders", "target": "silver.orders", "columns": ["order_id", "customer_id", "amount"]},
    {"source": "raw.products", "target": "silver.products", "columns": ["product_id", "sku", "price"]}
]

for table in metadata:
    print(f"\n Processing {table['source']} --> {table['target']}")

    selected_col = []
    for col in table['columns']:
        print(f"    Selecting: {col}")
        selected_col.append(col)