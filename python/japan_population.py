import pandas as pd
city_data = pd.read_csv("data/japan_population.csv")

def etl(city_data):
    total_population = city_data.loc[city_data["COUNTRYCODE"] == "JPN", "POPULATION"].sum()

    return pd.DataFrame({"Total JPN Population": [total_population]})

JPN_pop = etl(city_data)
print(JPN_pop)