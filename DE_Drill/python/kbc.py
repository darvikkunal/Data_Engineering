'''
KBC Game
1. Create a program capable of displaying questions to the user like KBC.
2. Use List data type to store the questions and their correct answers.
3. Display the final amount the person is taking home after playing the game.
'''

# STEP 1: Paste your big list of questions here
questions = [
    [
        "What is the capital of India?", 
        "Mumbai", "New Delhi", "Kolkata", "Chennai", 
        2
    ],
    [
        "Which planet is known as the Red Planet?", 
        "Venus", "Mars", "Jupiter", "Saturn", 
        2
    ],
    [
        "Who wrote the famous play 'Romeo and Juliet'?", 
        "Charles Dickens", "William Shakespeare", "Jane Austen", "Mark Twain", 
        2
    ],
    [
        "What is the largest ocean on Earth?", 
        "Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean", 
        4
    ],
    [
        "Which element has the chemical symbol 'O'?", 
        "Gold", "Oxygen", "Osmium", "Oganesson", 
        2
    ],
    [
        "In what year did India gain independence?", 
        "1945", "1947", "1950", "1952", 
        2
    ],
    [
        "What is the hardest natural substance on Earth?", 
        "Gold", "Iron", "Diamond", "Platinum", 
        3
    ],
    [
        "How many bones are there in the adult human body?", 
        "206", "208", "210", "212", 
        1
    ],
    [
        "Which gas is most abundant in the Earth's atmosphere?", 
        "Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen", 
        3
    ],
    [
        "Who is known as the 'Father of the Indian Constitution'?", 
        "Jawaharlal Nehru", "Mahatma Gandhi", "Dr. B.R. Ambedkar", "Sardar Vallabhbhai Patel", 
        3
    ],
    [
        "Which planet is closest to the Sun?", 
        "Venus", "Earth", "Mercury", "Mars", 
        3
    ],
    [
        "Who was the first person to walk on the Moon?", 
        "Yuri Gagarin", "Buzz Aldrin", "Neil Armstrong", "Michael Collins", 
        3
    ],
    [
        "Which programming language is named after a British comedy group (Monty Python)?", 
        "Java", "Python", "C++", "Ruby", 
        2
    ],
    [
        "What is the longest river in the world?", 
        "Amazon", "Nile", "Yangtze", "Mississippi", 
        2
    ],
    [
        "Which scientist proposed the theory of relativity (E=mc^2)?", 
        "Isaac Newton", "Nikola Tesla", "Galileo Galilei", "Albert Einstein", 
        4
    ]
]

# STEP 2: Create a variable to keep track of the prize money
total_money = 0

# STEP 3: Start a loop to go through the questions one by one
for i in range(len(questions)):
    
    # This grabs the current question we are on
    current_q = questions[i] 
    
    # STEP 4: Print the question 
    # (Remember: current_q[0] is the question text)
    print(f"\nQuestion {i + 1}:")
    print(current_q[0])
    
    # STEP 5: Print the 4 options nicely
    print(f"1. {current_q[1]}")
    print(f"2. {current_q[2]}")
    print(f"3. {current_q[3]}")
    print(f"4. {current_q[4]}")
    
    # ---------------------------------------------------------
    # YOUR TURN! FILL IN THE CODE BELOW THIS LINE
    # ---------------------------------------------------------
    
    # STEP 6: Ask the user for their answer. 
    # Hint: Use input(), but wrap it in int() so it becomes a number!
    # user_answer = ???
    user_answer = int(input("Enter your answer : "))
    
    # STEP 7: Check if they won!
    # Hint: Compare 'user_answer' to 'current_q[5]' (the secret answer number)
    
    # if user_answer == ???:
        # Print "Correct!"
        # Add some money to total_money (like total_money = total_money + 1000)
    # else:
        # Print "Wrong Answer! Game Over."
        # Use the 'break' keyword to stop the loop immediately
    if user_answer == current_q[5]:
        print(f"Correct Answer : {current_q[5]}")
        total_money += 1000
    else :
        correct_option = current_q[current_q[5]]
        print(f"You have answered the question : {current_q[0]} AS : {user_answer} \n THIS IS WRONG ANSWER \n THE CORRECT ANSWER is :  {correct_option}")
        break
# STEP 8: The Grand Finale
# (Make sure this is OUTSIDE the loop, totally unindented)
# Print a final message showing how much 'total_money' they take home!

print(f"Your Take Home Money is : {total_money}")