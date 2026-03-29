'''Create a function called order_summary that:

Takes a customer name as a normal argument
Takes any number of item prices via *args
Takes optional details via **kwargs (like city, priority, discount)
Prints the customer name, all items with their prices, total amount, and any extra details passed'''

def order_summary(name,*args,**kwargs):
    print(f"Customer name : {name} \n ")
    print(f"The list of arguments are : {list(args)} \n")
    print(f" The total is : ${float(round(sum(args),2))} \n")
    print(kwargs)
    for key, value in kwargs.items():
        print(f"{key.capitalize()} : {value} \n")

order_summary("lio" , 100.10 ,200.20,500 , city="Vizag", priority="low" , discount="10%" , ship="local")

