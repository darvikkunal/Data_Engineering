orders = [150.50, 890.00, 45.20, 1200.75, 320.00, 89.99, 4500.00, 210.30]

'''
Using lambda, map, and filter only (no for loops):

Apply a 10% discount to all orders and print the discounted amounts
Filter out only orders above 300
Filter orders above 300 and apply 10% discount to those filtered orders
'''
#lambda
l1 = lambda x: x * 0.90

#map
re1 = list(map(lambda x : x * 0.90,orders))
print(f"Map : {re1} \n")

#filter
f1 = list(filter(lambda x : x > 300, orders))
print(f"Filtered items : {f1} \n")

#filter
filtered = list(filter(lambda x : x>300,orders))

#applying discount
discount = list(map(lambda x:x * 0.90 , filtered))

print(f"The filtered is : {filtered} \n \n The discounted is : {discount}")