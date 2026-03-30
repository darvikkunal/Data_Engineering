You are given a dataset containing information about various cities around the world. Your task is to calculate the total population of all cities in Japan. The COUNTRYCODE for Japan is "JPN".

📥 Input Format
The dataset is named:

city_data (for PySpark, Scala, or Python DataFrame)

jcp_city_pop (for SQL or DBT)

It has the following schema:

Column Name	Type	Description
Id	NUMBER	Unique ID of the city
Name	VARCHAR	Name of the city
COUNTRYCODE	VARCHAR	Country code in ISO format
DISTRICT	VARCHAR	District/Region of the city
POPULATION	NUMBER	Population of the city
📊 Sample Input
Id	Name	COUNTRYCODE	DISTRICT	POPULATION
1	Tokyo	JPN	Kanto	13,929,286
2	Osaka	JPN	Kansai	2,691,167
3	Kyoto	JPN	Kansai	1,474,570
4	Nagoya	JPN	Chubu	2,304,879
5	Fukuoka	JPN	Kyushu	1,587,352
6	Hiroshima	JPN	Chugoku	1,192,011
✅ Expected Output
Total Population
23,179,265
✅ Constraints
Assume all column names and values are case-sensitive.

The country code "JPN" must be used to filter for Japanese cities.

You should only return one column named Total Population