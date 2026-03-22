'''
Python — Exercise 10

Create a contact book program using a dictionary. It should let the user:

Add a contact (name → phone number)
Search a contact by name
Delete a contact
View all contacts
Quit


Use a while loop with a menu so the user can keep performing actions until they quit.
'''

contacts = {}

while True:
    print("Enter 1 to ADD : ")
    print("Enter 2 to SEARCH : ")
    print("Enter 3 to DELETE : ")
    print("Enter 4 to VIEW : ")
    print("Enter 5 to QUIT : ")
    try:
        choice = int(input("Enter your choice : "))
    except ValueError:
        print("Please enter a number!!!")
        continue

    if choice == 1:
        name = input("Enter name : ")
        phone = int(input("Enter number : "))
        '''When you do contacts[name] = phone — name is a variable holding whatever the user typed (like "Kunal"), so it becomes the key. 
        This is different from contacts["name"] which uses the literal string "name" as the key 
        — every contact would overwrite the same key!'''
        contacts[name] = phone
    elif choice == 2:
        name = input("Enter name : ")
        if name in contacts:
            print(contacts[name])
        else:
            print("Not FOUND")
    elif choice == 3:
        name = input("Enter name : ")
        if name in contacts:
            del contacts[name]
        else:
            print("NOT FOUND")
    elif choice == 4:
        for name, phone in contacts.items():
            print(name , phone)
    elif choice == 5:
        print("EXITING THE PROGRAM")
        break


