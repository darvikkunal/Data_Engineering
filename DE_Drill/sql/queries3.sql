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