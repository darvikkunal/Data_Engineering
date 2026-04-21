import logging

logging.basicConfig(level=logging.INFO , filename='/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/file2.txt', filemode='w',
                    format='%(asctime)s - %(levelname)s - %(message)s')

x = 2
logging.info(f"The value of x is : {x} ")

logging.debug("debug")
logging.info("info")
logging.warning("warning")
logging.error("error")
logging.critical("critical")

try:
    1/0
except ZeroDivisionError as e:
    logging.error("ZeroDivisionError", exc_info=True)
    logging.exception("test error")