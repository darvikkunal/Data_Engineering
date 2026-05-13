/*
Use EXPLAIN to analyse the following query and then rewrite it in a more optimised way using a CTE to filter early
*/

EXPLAIN 
SELECT
    c.CompanyName, sum(od.Unitprice * od.quantity) as revenue
FROM orders o
JOIN customers c ON o.customerID = c.CustomerID
JOIN order_details od ON o.orderID = od.OrderID
WHERE YEAR(o.orderDate) = 1997
GROUP BY c.CompanyName
ORDER BY revenue DESC ;

EXPLAIN 
WITH orders_1997 AS (
    SELECT OrderID, CustomerID
    FROM orders
    WHERE YEAR(OrderDate) = 1997  -- filter BEFORE joining
),
revenue AS (
    SELECT o.CustomerID,
           SUM(od.UnitPrice * od.Quantity) as revenue
    FROM orders_1997 o
    JOIN order_details od ON o.OrderID = od.OrderID
    GROUP BY 1
)
SELECT c.CompanyName, r.revenue
FROM revenue r
JOIN customers c ON r.CustomerID = c.CustomerID
ORDER BY revenue DESC;


SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(od.UnitPrice * od.Quantity) as total_revenue
FROM employees e
JOIN orders o ON e.EmployeeID = o.EmployeeID
JOIN order_details od ON o.OrderID = od.OrderID
--JOIN order_details od2 ON od.OrderID = od2.OrderID  -- spot the bug!
GROUP BY 1, 2, 3
ORDER BY total_revenue DESC;

/*
Problem 27 — Hard
AI SQL Validation — the following AI-generated query claims to find the average order value per customer, only for customers who have placed more than 5 orders.
Find ALL the bugs and rewrite it correctly.
There are 3 bugs. Think about:
What table is missing?
What does AVG(UnitPrice * Quantity) actually calculate?
Is COUNT(OrderID) counting the right thing?
*/
-- Step 1: revenue per ORDER
WITH order_revenue AS (
    SELECT o.OrderID, o.CustomerID,
           SUM(od.UnitPrice * od.Quantity) as order_value
    FROM order_details od
    JOIN orders o ON od.OrderID = o.OrderID
    GROUP BY 1, 2          -- one row per order
),
-- Step 2: avg order value + count per CUSTOMER
customer_stats AS (
    SELECT CustomerID,
           AVG(order_value) as avg_order_value,  -- avg across orders
           COUNT(OrderID) as total_orders
    FROM order_revenue
    GROUP BY CustomerID
)
SELECT CustomerID, avg_order_value, total_orders
FROM customer_stats
WHERE total_orders > 5
ORDER BY avg_order_value DESC;


/*
🗄️ SQL Problem #29 — Medium
The Challenge:
Find the top 3 employees by total number of orders handled, but only count orders from the year 1997. Show EmployeeID, FirstName, LastName, total_orders.
Tables: employees, orders

Hints:

Filter orders WHERE YEAR(OrderDate) = 1997 FIRST
GROUP BY employee, COUNT orders
RANK or LIMIT to get top 3
*/

SELECT 
	e.EmployeeID, e.FirstName, e.LastName, count(o.orderid) as total_orders
FROM employees e
JOIN orders o ON e.employeeID = o.employeeID
WHERE YEAR(o.orderdate) = 1997
group by 1,2,3
order by total_orders DESC
LIMIT 3;



/*
🗄️ SQL Problem #30 — Medium/Hard
The Challenge:
For each category, find:

category_name
total_products — how many products are in that category
avg_unit_price — average unit price of products (rounded to 2 decimals)
most_expensive_product — name of the most expensive product in that category

Show only categories where avg_unit_price > 20. Order by avg_unit_price DESC.
Tables: categories, products
*/
-- Step 1: CTE to get most expensive product per category
SELECT
    c.categoryname,
    COUNT(p.productid) as total_products,
    ROUND(AVG(p.unitprice), 2) as avg_unit_price,
    MAX(sub.most_expensive_product) as most_expensive_product
FROM products p
JOIN categories c ON p.categoryid = c.categoryid
JOIN (
    SELECT
        categoryid,
        FIRST_VALUE(productname) OVER(
            PARTITION BY categoryid
            ORDER BY unitprice DESC
        ) as most_expensive_product
    FROM products
) sub ON c.categoryid = sub.categoryid
GROUP BY 1
HAVING ROUND(AVG(p.unitprice), 2) > 20
ORDER BY avg_unit_price DESC;



/*
SQL Problem #31 — Medium/Hard
Find all customers who placed more than 5 orders AND whose average order value (quantity × unit price) is above 1000. 
Show customerid, companyname, total_orders, avg_order_value (rounded to 2 decimals). Order by avg_order_value DESC.
Tables: customers, orders, order_details
*/

WITH order_totals AS (
    SELECT 
        o.customerid,
        o.orderid,
        SUM(od.quantity * od.unitprice) as order_value
    FROM orders o
    JOIN order_details od ON o.orderid = od.orderid
    GROUP BY 1, 2
)
select 
	c.customerid, c.companyname, count(ot.orderid) as total_orders , round(avg(ot.order_value),2) as avg_order_value
from customers c 
JOIN order_totals ot ON c.customerid = ot.customerid
group by 1,2
having count(ot.orderid) > 5 AND round(avg(ot.order_value),2) > 1000
order by avg_order_value DESC;

/*
🗄️ SQL Problem #32 — Hard
Find the month-over-month revenue growth % for each month in 1997.
Show: month, total_revenue, prev_month_revenue, growth_pct (rounded to 2 decimals)
Tables: orders, order_details
*/

with monthly_revenue as (
	select month(o.orderdate) as month, 
	sum(od.unitprice * od.quantity) as total_revenue
	from orders o JOIN order_details od ON o.orderid = od.orderid
	where YEAR(o.orderdate) = 1997
	GROUP BY MONTH(o.orderdate)
)
select
	month,
	total_revenue,
	LAG(total_revenue) OVER (ORDER BY month) as perv_month_revenue,
	ROUND(
	((total_revenue - LAG(total_revenue) OVER (ORDER BY MONTH)) /
	LAG(total_revenue) OVER (ORDER BY month)) * 100, 2) as growth_pct
FROM monthly_revenue
ORDER BY month;