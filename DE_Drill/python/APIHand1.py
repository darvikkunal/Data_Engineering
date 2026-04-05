'''
API Handling
Create a program that:

Calls this free public API: https://jsonplaceholder.typicode.com/users

Prints each user's name, email, and city (city is inside address)

Prints the total number of users returned

Filters and prints only users whose company name contains the word "LLC"
'''

import requests
url = 'https://jsonplaceholder.typicode.com/users'

response = requests.get(url)

if response.status_code == 200 :
    data = response.json()
    print(f"Status Code : {response.status_code}")
    print(f"Total Users : {len(data)} \n")


    for user in data:
        print(f"Name : {user['name']}")
        print(f"Email : {user['email']}")
        print(f"City : {user['address']['city']} \n")

        
        if 'LLC' in user['company']['name']:
            print(f"Company Name : {user['company']['name']}")
