"""
 Python — Exercise 3

Create a program that asks the user to enter a temperature in Celsius and converts it to Fahrenheit and Kelvin. Format the output to 2 decimal places.

Formula:

Fahrenheit = (Celsius * 9/5) + 32
Kelvin = Celsius + 273.15
"""

Celsius = float(input("Enter temperature in Celsius : "))
Fahrenheit = (Celsius * 9/5) + 32
Kelvin = Celsius + 273.15
print(f"The Fahrenheit temperature is : {Fahrenheit:.2f} F")
print(f"The Kelvin temperature is : {Kelvin:.2f} K")



