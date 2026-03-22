"""
Exercise 1 - Create a Calculator
Create a calculator capable of performing addition, subtraction, multiplication and division operations on two numbers. Your program should format the output in a readable manner!
"""

a = int(input("Enter your first number : "))
b = int(input("Enter your second number : "))
operation = input("Enter the operation you want to perform ['+' , '-' , '*', '/' , '//' '%' '**']: ")

if operation == '+':
    print(f"The Sum is : {a+b}")
elif operation == '-':
    print(f"The Difference is : {a-b}")
elif operation == '*':
    print(f"The Product is : {a*b}")
elif operation in ('/','//','%'):
    #Checking for division by zero
    if b == 0:
        print("Error : Cannot divide by Zero!")
    elif operation == '//':
        print(f"The Floor Division is : {a//b}")
    elif operation == '/':
        print(f"The Division is : {a/b}")
    elif operation == '%':
        print(f"The Modulo (Reminder) is : {a%b}")        
elif operation == '**':
    print(f"The exponential is : {a**b}")
else :
    print("WRONG INPUT TRY AGAIN!!!")

print('\n')
print("----------OVERALL MESSAGE-----------------")
print(f"The Sum is : {a+b}")
print(f"The Difference is : {a-b}")
print(f"The Product is : {a*b}")
print(f"The exponential is : {a**b}")
if b!= 0:
    print(f"The Division is : {a/b}")
    print(f"The Floor Division is : {a//b}")
    print(f"The Modulo (Remainder) is : {a%b}")
else:
    print("Division/Modulo: Cannot divide by zero!")
