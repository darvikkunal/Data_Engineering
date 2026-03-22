'''
Exercise 9

Create a program that:

Asks the user to enter any sentence
Writes it to a text file called output.txt
Reads it back from the file and prints it
Also prints the total number of words in the sentence


Hint: use open() with modes 'w' for write and 'r' for read. Use with keyword — it auto-closes the file cleanly.
'''
file_path = '/Users/darvikkunalbanda/DataEngineering/DE_Drill/python/output.txt'
def user_file():
    sentence = input("Enter a string : ").strip()

    if not sentence:
        print("Please enter a valid sentence")
        return

    with open(file_path,'w') as f:
        f.write(sentence)

    with open(file_path,'r') as f:
        file_content = f.read()
        words = file_content.split()
        
        print(f"The file contents are : {file_content} \n")
        print(f"The word count is : {len(words)}")

    

user_file()
