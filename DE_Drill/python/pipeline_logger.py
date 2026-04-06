'''
Python — Exercise 20: Logging Module
Create a program that:

Sets up logging to write to a file called pipeline.log
Logs an INFO message when the pipeline starts
Logs a WARNING when a value is missing or unexpected
Logs an ERROR when something fails (simulate with a try/except)
Logs an INFO when the pipeline finishes
Print the contents of pipeline.log at the end to verify
'''

import logging
file_path = '/Users/darvikkunalbanda/DataEngineering/logs/pipeline_logger.log'

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s',
    filename= file_path
)

logging.info('pipeline started \n')

import requests
url = 'https://jsonplaceholder.typicode.com/user'
try:
    response = requests.get(url)
    if response.status_code == 200 :
        logging.info(f'Status code : {response.status_code}')
        logging.info('pipeline completed all steps')
    else:
        logging.warning(f'pipeline did not complete all steps : {response.status_code}')
        raise ValueError (f"Bad status: {response.status_code}")
         
except Exception as e:
        logging.error(f'Unexpected status : {e}')
    
with open(file_path) as f:
     print(f.read())

