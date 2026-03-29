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
import random as rnd

def secret_code():
    code = input("Enter if you wanna code or de-code : ")
    if code.lower() == 'code':
        word = input("Enter your code word :")
        if len(word) >= 3:
            removed = word[0].remove()
            de_code = removed.append()
            de_code = word.append(rnd(3))
            de_code = word[0].append(rnd(3))
            print(f"The de-code word is {de_code}")
        else:
            de_code = word[::-1]
            print(f"The de-code word is {de_code}")
    elif code.lower() == 'decode':
        if len(word) <3 :
            coded = word[::-1]
            print(f"The coded word is {coded}")
        else:
            coded = word.remove[:-3]
            coded = word.remove[2:]
            coded = word.remove[:-1]
            coded = word.append[0:]
            print(f"The coded word is {coded}")
    else:
        print("YOU HAVE ENTERED WRONG ONE!")

