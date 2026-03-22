'''
Excersice 2: Good Morning Sir
Create a python program capable of greeting you with Good Morning, Good Afternoon and Good Evening. 
Your program should use time module to get the current hour. 
Here is a sample program and documentation link for you:
'''
import time
timestamp = int(time.strftime('%H'))
currenttime = time.strftime('%H:%M:%S')

if timestamp < 12:
    print(f'Good Morning \n Time is :{currenttime}')
elif timestamp >= 12 and timestamp < 17:
    print(f"Good Afternoon \n Time is :{currenttime}")
elif timestamp >= 17 and timestamp < 21:
    print(f'Good Evening \n Time is :{currenttime}')
else:
    print(f'Good Night \n Time is :{currenttime}')