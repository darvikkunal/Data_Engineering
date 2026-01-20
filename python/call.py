import pandas as pd
import numpy as np
import datetime

df_calls = pd.read_csv("/Users/darvikkunalbanda/Data_Engineering/data/calls.csv")
df_customers = pd.read_csv("/Users/darvikkunalbanda/Data_Engineering/data/customers.csv")


def etl(df_calls, df_customers):
    joined_df = pd.merge(df_calls , df_customers , on = "cust_id")
    agg_df = joined_df.groupby("date").agg(
        num_customers = ("cust_id", "nunique"),
        num_calls = ("duration", "sum")
    )
    return agg_df.reset_index()

# Call the function
result = etl(df_calls,df_customers)
print(result)