#messy_pipeline.py

import json
import csv
from datetime import datetime

data = []
with open('/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/orders.csv','r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        data.append(row)


result = []
for order in data:
    price = float(order['price'])
    quantity = int(order['quantity'])
    if quantity > 5 and price > 100:
        order_value = quantity * price
        discount = order_value * 0.1 if order_value > 500 else 0
        final_price = order_value - discount
        result.append({'order_id': order['id'], 'final_price':final_price, 'discount': discount})

with open('output.json', 'w') as f:
    json.dump(result,f)

print(f"Processed {len(result)} orders at {datetime.now()}")

