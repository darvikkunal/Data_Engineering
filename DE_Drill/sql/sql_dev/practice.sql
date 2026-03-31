/* 
Create a table country_population
Insert 4–5 rows (mix of countries and years).
Update one population value, delete one row, and select all rows to verify.
*/

CREATE TABLE country_population (
    country       VARCHAR(100),
    year          INT,
    population_m  INT
);

INSERT INTO country_population ( country , year , population_m)
VALUES
    ('India',2020,1380),
    ('India',2022,1410),
    ('USA',2018,8908),
    ('USA', 2022, 333),
    ('Germany', 2021, 83),
    ('JAPAN',2021,456),
    ('JAPAN',2022,520);

UPDATE country_population set population_m = 1440
where country = 'India' AND year = 2022;

DELETE FROM country_population WHERE country = 'USA' and year = 2018;

select * from country_population;

/* SELECT + WHERE + ORDER BY
Select all rows where country = 'Japan'.

Select rows where year >= 2010 ordered by year descending.

Select rows where population_m is between 50 and 150 (use BETWEEN or >=/<=)
*/

select * from country_population where country = 'JAPAN';

select * from country_population where year >= 2010 ORDER BY year desc;

select * from country_population where population_m BETWEEN 50 and 150;
select * from country_population where population_m >=50 and population_m <= 150;

/*
3. String functions
Using a table with a country or customer_name column:

Show original name and a cleaned version:
*/
select 
    concat(FirstName, ' ',LastName) as RawFullName,
    UPPER(TRIM(concat(FirstName, ' ',LastName))) as CleanFullName
from sales.Customers;

-- Only rows where country is “india” in any case or with space
select * from country_population where LOWER(TRIM(country)) = 'India';

/*
4. Number functions
On a numeric column amount:

Show amount, ROUND(amount, 2) and ABS(amount) with aliases.

Select only rows where ABS(amount) > 100.
*/

select population_m , ROUND(population_m,2) as rnd_population , ABS(population_m) as ABS_population from country_population where ABS(population_m) > 100; 

/*
5. Joins
Assume customers(customer_id, customer_name, country) and
orders(order_id, customer_id, total_amount).

Inner join
*/

select 
    c.CustomerID, c.FirstName, c.Country,
    o.OrderID,SUM(o.Sales) as total_amount
from sales.Customers c
INNER JOIN Sales.Orders o ON c.CustomerID=o.CustomerID 
GROUP BY c.CustomerID, c.FirstName, c.Country,o.OrderID;

-- Left join to find customers with no orders

select 
    c.CustomerID, c.FirstName, c.Country,o.OrderID
FROM Sales.Customers c
LEFT JOIN sales.Orders o ON c.CustomerID = o.CustomerID
where o.OrderID is null;

/*
6. Aggregates + GROUP BY
On orders or payments:
Average order value per customer
*/
select 
    c.CustomerID, c.FirstName,o.OrderID,o.sales, count(coalesce(o.orderid,0)) as order_count,
    avg(COALESCE(o.sales,0)) as avg_sales
FROM Sales.Customers c
LEFT JOIN sales.Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName,o.OrderID,o.sales
HAVING count(coalesce(o.orderid,0)) >= 3;
