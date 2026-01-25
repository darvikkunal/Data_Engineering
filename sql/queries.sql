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

                            --- Filtering Data ---

-- Retrieve all the customers from Germany
select * from customers
where country = 'Germany';

-- Retrieve all the customers not from Germany
select * from customers
where country != 'Germany';

-- Retrieve all the customers who score is > 500
select * from customers
where score > 500;

-- Retrieve all the customers who score is > 500 or more
select * from customers
where score >= 500;

-- Retrieve all the customers who score is < 500
select * from customers
where score < 500;

-- Retrieve all the customers who score is < 500 or less
select * from customers
where score <= 500;

-- Retrieve all customers who are from USA and have a score greater than 500
select * from customers where country = 'USA' and score > 500;

-- Retrieve all customers who are either from USA OR have a score greater than 500
select * from customers where country = 'USA' OR score > 500;

-- Retrieve all the customers who score is not < 500
select * from customers
where NOT score < 500;

-- Retrieve all the customers whose score falls in the range between 100 and 500
--Method 1
select * from customers
where score BETWEEN 100 AND 500;
--Method 2
select * from customers
where score >= 100 AND score <=500;

-- Retrieve all customers from either Germany or USA
select * from customers
where country in ('Germany' ,'USA');

-- Retrieve all customers whose first name starts with "M"
select * from customers
where first_name like 'M%';

-- Retrieve all customers whose first name ends with "N"
select * from customers
where first_name like '%N';

-- Find all customers whose first name contains 'r'
select * from customers
where first_name like '%r%';

-- Find all customers whose first name contains 'r' in the third position
select * from customers
where first_name like '__r%';

                            --- BASIC JOINS ---

-- Retrieve all data from customers and orders as separate results
select * from customers;
select * from orders;

-- INNER JOIN --> Get all customers along with their orders, but only for customers who have placed an order
select c.id, c.first_name, o.order_id , o.sales 
FROM customers c
INNER JOIN orders o on c.id = o.customer_id;

-- LEFT JOIN --> Get all customers along with their orders, including those without orders
select c.id , c.first_name , c.country , c.score , o.order_id ,o.order_date ,o.sales
from customers c
LEFT JOIN orders o on c.id = o.customer_id;

-- RIGHT JOIN --> Get all customers along with their orders, including orders without matching customers
select c.id , c.first_name , c.country , c.score , o.order_id ,o.order_date ,o.sales
from customers c
RIGHT JOIN orders o on c.id = o.customer_id;
-- LEFT JOIN --> Get all customers along with their orders, including those without orders [Tables Switching]
select c.id , c.first_name , c.country , c.score , o.order_id ,o.order_date ,o.sales
from  orders o
RIGHT JOIN customers c on c.id = o.customer_id;
-- Full Join --> Get all customers and all orders, even if there's no match
select c.id , c.first_name , c.country , c.score , o.order_id ,o.order_date ,o.sales
from  orders o
FULL JOIN customers c on c.id = o.customer_id;

                            --- ADVANCED JOINS ---
-- LEFT ANTI_JOIN --> Get all customers who haven't placed any order
SELECT *
from customers c
LEFT JOIN orders o on c.id = o.customer_id
WHERE o.customer_id IS NULL;

-- Right anti join --> Get all orders without mathching customers
SELECT *
from customers c
RIGHT JOIN orders o on c.id = o.customer_id
WHERE c.id IS NULL;

-- Get all orders without matching customers (using Left Join)
SELECT *
from orders o
LEFT JOIN customers c on  o.customer_id = c.id
WHERE c.id IS NULL;

-- Full Anti Join --> Find customers without orders and orders without customers 
SELECT *
from customers c
FULL JOIN orders o on c.id = o.customer_id
WHERE o.customer_id IS NULL OR c.id IS NULL;

-- Get all customers along with their orders, but only for customers who have placed an order (without using INNER JOIN)
SELECT *
from customers c
LEFT JOIN orders o on c.id = o.customer_id
WHERE o.customer_id IS NOT NULL;

-- Cross JOIN --> Generate all possible combination of customers and orders
SELECT *
FROM customers
CROSS JOIN orders;

-- Using SalesDB, retrieve a list of all orders, along with the related customer, product, and employee details.
--For each order, display:
-- Order ID
-- Customer's name
-- Product name
-- Sales amount
-- Product price
-- Salesperson's name

USE SalesDB;

select o.OrderID , CONCAT (c.FirstName,' ',c.LastName) as Customer_nm ,(o.Quantity*o.Sales) as sales_amount, p.Product ,
p.Price , CONCAT (e.FirstName,' ',e.LastName) as Salesperson_nm 
from 
    sales.Orders o
LEFT JOIN Sales.Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN sales.Products p on o.ProductID = p.ProductID
LEFT JOIN sales.Employees e ON o.SalesPersonID = e.EmployeeID;
