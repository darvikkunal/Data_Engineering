import json
import csv 
import logging
from datetime import datetime
from typing import List,Dict

# CONSTRANTS
DISCOUNT_THRESHOLD = 500
DISCOUNT_RATE = 0.1
QUANTITY_MIN = 5
PRICE_MIN = 100
INPUT_FILE = '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/orders.csv'
OUTPUT_FILE = '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/output.json'

# Logging
logging.basicConfig(
    level=logging.INFO,
    format = '%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Functions

def load_orders(filepath:str) -> List[Dict]:
    ''' Load orders from a csv file
        Args : filepath : path to csv file 
        Returns : List of orders dictionaries'''
    try:
        orders = []
        with open(filepath, 'r') as f:
            reader = csv.DictReader(f)
            for row in reader:
                orders.append(row)
        logger.info(f"Loaded {len(orders)} orders from {filepath}")
        return orders
    except FileNotFoundError:
        logger.error(f"File not found : {filepath}")
        return []
    

def is_qualifying_order(order: Dict) -> bool:
    '''Check if an order qualifies for processing.
        Qualifies if quantity > 5 AND price > 100
        Args : orders : order dictionary
        Returns : True if order qualifies, False otherwise'''
    try:
        quantity = int(order['quantity'])
        price = float(order['price'])
        return quantity > QUANTITY_MIN and price > PRICE_MIN
    except (ValueError , KeyError) as e:
        logger.warning(f"Error processing order {order.get('id' , 'UNKNOW')} : {e}")
        return False
    
def calculate_order_value(order:Dict) -> float:
    '''Calculate total order value (quantity * price)
        Args : order: order dictionary
        Returns: order value as foat '''
    quantity = int(order['quantity'])
    price = float(order['price'])
    return quantity * price

def apply_discount(order_value:float) -> float:
    '''Calculate discount amount
        If order_value > 500, apply 10% discount, else 0
        Args : order_value: Total order value
        Returns : Discount amount'''
    if order_value > DISCOUNT_THRESHOLD:
        return order_value * DISCOUNT_RATE
    return 0

def process_order(order: Dict) -> Dict:
    '''Process a single order: calculate value, apply discount, return result
        Args : order dictionary
        Returns : processed order with id, final_price , discount'''
    order_value = calculate_order_value(order)
    discount = apply_discount(order_value)
    final_price = order_value - discount

    return {
        'order_id': order['id'],
        'final_price': round(final_price,2),
        'discount': round(discount,2)
    }

def process_orders(orders: List[Dict]) -> List[Dict]:
    ''' Filter qualifying orders and process them
        Args: orders : List of all orders
        Returns : List of processed qualifying orders'''
    
    processed_orders = []
    for order in orders:
        if is_qualifying_order(order):
            processed_order = process_order(order)
            processed_orders.append(processed_order)
    logger.info(f"Processed {len(processed_orders)} qualifying orders")
    return processed_orders

def save_results(results: List[Dict], filepath: str) -> None:
    ''' save processed orders to a JSON file.
        Args: results: List of processed orders
        filepath: output file path'''
    try:
        with open(filepath, 'w') as f:
            json.dump(results, f, indent=2)
        logger.info(f"Saved {len(results)} results to {filepath}")
    except Exception as e:
        logger.error(f"Error saving results : {e}")

def main():
    '''Main pipeline: load orders, process, save results'''
    logger.info("Starting order processing pipeline")

    # load orders
    orders = load_orders(INPUT_FILE)
    if not orders:
        logger.error("No orders loaded. Exiting.")
        return
    
    #process orders
    processed_orders = process_orders(orders)

    # save results
    save_results(processed_orders, OUTPUT_FILE)

    logger.info(f"Pipeline complete. Processed {len(processed_orders)} orders at {datetime.now()}")

if __name__ == '__main__':
    main()