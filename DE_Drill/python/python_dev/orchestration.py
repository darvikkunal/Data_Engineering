'''
Receive an email from the user
Validate the email
If it is invalid, Log an error in a file
If it is valid, Clean and structure the email
Log each step of the program
'''

# Action Function
def write_logs(message):
    with open(r"/Users/darvikkunalbanda/DataEngineering/logs/python_app.log",'a') as file:
        file.write(message + "\n" + '\n')


# Validation Function
def is_valid_email(email):
    return '@' in email and '.' in email


# Transformation Function
def clean_and_split_email(email):
    cl_email = email.strip().lower()
    username , domain = cl_email.split('@')
    return{'username': username,
           'domain':domain}

#Orchestrator Function
def process_user_email(email):
    '''Orchestration FUNCTION'''
    write_logs('App Started')
    # Receive an email from the user

    # Validate the email
    # If it is invalid, Log an error in a file
    if not is_valid_email(email):
        write_logs(f"Invalid Email recieved : {email}")
    else:
        clean_email = clean_and_split_email(email)
        write_logs(f"Processed Email: {clean_email}")
    write_logs('App Stopped')
# If it is valid, Clean and structure the email

# Log each step of the program


email = input("Please enter your Email :")
process_user_email(email)