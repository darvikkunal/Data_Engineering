select name from sys.databases;



USE SalesDB;
SELECT *
FROM Sales.Customers;

USE MyDatabase;
-- Retrieve All customers
SELECT *
FROM MyDatabase.dbo.customers;
-- Retrieve All order Data
SELECT *
FROM MyDatabase.dbo.orders;

-- Retrieve each customer's name, country and score
SELECT 
    first_name,
    country,
    score
FROM MyDatabase.dbo.customers;

-- Retrieve customers with a score not equal to 0
SELECT *
FROM MyDatabase.dbo.customers
WHERE score != 0;

-- Retrieve customers with country Germany
SELECT *
FROM MyDatabase.dbo.customers
WHERE country = 'Germany';

-- Retrieve all customers and sort the results by the country in asc and highest score first 
SELECT *
FROM MyDatabase.dbo.customers
ORDER BY country ASC , score DESC;

--Find the total score for each country
SELECT country , sum(score) as total_score
FROM MyDatabase.dbo.customers
GROUP BY country;

-- Find the total score and total number of customers for each contry
SELECT country, sum(score) as total_score , count(*) as no_of_customers
FROM MyDatabase.dbo.customers
GROUP BY country;

-- Find the average score for each country considering only customers with a score not equal to 0
-- And return only those countries with an average score greater than 430

select country , avg(score) as avg_score
FROM MyDatabase.dbo.customers
WHERE score != 0
GROUP BY country
HAVING avg(score) > 430;

-- Return unique list of countries
select distinct(country) as unq_countries
from MyDatabase.dbo.customers;

-- Retrieve only 3 customers with HIghest score
select TOP 3 *
from MyDatabase.dbo.customers
order by score desc;

-- Retrieve the lowest 2 customers based on the score
select TOP 2 *
from MyDatabase.dbo.customers
order by score ASC;

-- Get the two most recent orders from orders table
select TOP 2 *
FROM MyDatabase.dbo.orders
order by order_date desc;

                            --- DDL Commands ---

-- Create a new table called persons with columns: id, person_name, birth_date and phone

CREATE TABLE persons (
    id INT NOT NULL,
    person_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    CONSTRAINT pk_persons PRIMARY KEY (id)
);
SELECT * FROM persons;

-- Add a new column called email to the persons table

ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;

-- Remove the column phone from the persons table

ALTER TABLE persons
DROP COLUMN phone; 

-- Delete the table persons from the database

DROP table persons;

                                        --- DML Commands ---

-- INSERT --
select * from customers;
INSERT INTO customers (id, first_name , country , score)
VALUES 
    (8, 'BELLA', 'INDIA' , 900),
    (9,'SamLIP', NULL , 100),
    (10, 'KLPIECH', 'AUZI' , 01);


-- Copy data from 'customers' table into 'persons'
INSERT INTO persons (id,person_name , birth_date , phone)
SELECT 
    id , first_name , NULL as NULL_COL , 'Unknown' as UNKNOWN
FROM customers;

SELECT * FROM persons;

-- Change the score of customer with ID 6 to 0
UPDATE customers
SET score = 0
WHERE id = 6;

select * from customers;

-- Change the score of customer with ID 10 to 0 and update the country to 'UK' 
UPDATE customers
SET 
    score = 0,
    country = 'UK'
WHERE id = 10;

-- UPDATE ALL CUSTOMERS WITH A NULL SCORE BY SETTING THEIR SCORE TO 0
UPDATE customers
SET
    score = 0
WHERE SCORE IS NULL;

-- DELETE ALL CUSTOMERS WITH AN ID GREATER THAN 5
DELETE FROM customers
WHERE ID > 5;

-- DELETE ALL DATA FROM TABLE PERSONS
TRUNCATE TABLE PERSONS;