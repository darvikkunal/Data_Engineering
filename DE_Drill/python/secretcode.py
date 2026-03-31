# Write a python program to translate a message into secret code language. Use the rules below
#to translate normal English into secret code language
# Coding:
# if the word contains atleast 3 characters, remove the first letter and append it at the end
# now append three random characters at the starting and the end
# else: simply reverse the string
# Decoding:
# if the word contains less than 3 characters, reverse it
# else:
#remove 3 random characters from start and end. Now remove the last letter and append it to
#the beginning
# Your program should ask whether you want to code or decode
import random , string

def secret_code():
    code = input("Enter if you wanna code or de-code : ")
    word = input("Enter your code word :") #hello
    if code.lower() == 'code':
        if len(word) >= 3:
            s1 = word[1:] #everything after first letter ;  ello
            s2 = word[0] #just the first letter. ; h
            s3 = s1 + s2 #elloh
            rand1 = ''.join(random.choices(string.ascii_letters, k=3)).lower()
            rand2 = ''.join(random.choices(string.ascii_letters, k=3)).lower()
            de_code = rand1 + s3 + rand2
            print(f"The de-code word is {de_code}")
        else:
            de_code = word[::-1]
            print(f"The de-code word is : {de_code}")
    elif code.lower() == 'decode':
        if len(word) <3 :
            coded = word[::-1]
            print(f"The coded word is : {coded}")
        else:
            st1 = word[3:-3] #removes 3 from start and 3 from end
            st2 = st1[-1] + st1[:-1]
            print(f"The coded word is {st2}")
    else:
        print("YOU HAVE ENTERED WRONG ONE! PLEASE CHECK!!! \n")
    return


secret_code()
