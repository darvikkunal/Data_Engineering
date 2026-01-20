CREATE TABLE jcp_city_pop (
    Id INT,
    Name VARCHAR(100),
    COUNTRYCODE VARCHAR(10),
    DISTRICT VARCHAR(100),
    POPULATION INT
);

INSERT INTO jcp_city_pop (Id, Name, COUNTRYCODE, DISTRICT, POPULATION) VALUES
(1, 'Tokyo', 'JPN', 'Kanto', 13929286),
(2, 'Osaka', 'JPN', 'Kansai', 2691167),
(3, 'Kyoto', 'JPN', 'Kansai', 1474570),
(4, 'Nagoya', 'JPN', 'Chubu', 2304879),
(5, 'Fukuoka', 'JPN', 'Kyushu', 1587352),
(6, 'Hiroshima', 'JPN', 'Chugoku', 1192011);

--You are given a table containing information about various cities around the world. 
--Your task is to calculate the total population of all cities in Japan. The COUNTRYCODE for Japan is "JPN".
select sum(POPULATION) as JPN_Total_Population 
from jcp_city_pop
WHERE COUNTRYCODE = 'JPN';