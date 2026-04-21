'''Exercise 21: Decorators
Create a program that:

Writes a decorator called timer that measures how long a function takes to run
Writes a decorator called logger that prints the function name before and after it runs
Applies both decorators to a function called process_data that simulates work with time.sleep(1)
Tests it by calling process_data()'''

import time

def timer(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.2f} seconds")
        return result
    return wrapper

def logger(func):
    def wrapper(*args,**kwargs):
        print(f"Starting: {func.__name__}")
        result = func(*args,**kwargs)
        print(f"Finished: {func.__name__}")
        return result
    return wrapper
@timer
@logger

def process_data():
    time.sleep(1)

process_data()