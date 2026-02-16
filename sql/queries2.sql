---     WINDOW Functions      ---
-- Find the total sales across all orders
use SalesDB;

select
    ProductID,
    sum(Sales) totalsales
from sales.Orders
GROUP BY ProductID;

-- Find the total sales for each product, additionall provide details such order id & order date

select
    PRODUCTID,
    OrderID,
    orderDate,
    sum(sales) OVER(PARTITION BY ProductID) total_sales
from Sales.Orders;

-- Find the total sales across all orders and for each product, additionall provide details such order id & order date
-- Find the total sales for each combination of products and order status

select
    orderID,
    productID,
    orderDate,
    Sales,
    orderstatus,
    sum(Sales) OVER () TotalSales,
    sum(sales) OVER (PARTITION BY ProductID) total_salesbyproductID,
    sum(sales) OVER (PARTITION BY PRODUCTID , ORDERSTATUS) PRODDUCTORDERSTATUS
from Sales.Orders;

-- RANK EACH ORDER BASED ON THEIR SALES FROM HIGHEST TO LOWEST, ADDITIONALLY PROVIDE DETAILS SUCH ORDERID & ORDERDATE

select
    orderID,
    orderDATE,
    sales,
    RANK() OVER (ORDER BY sales desc) totalsales
from Sales.Orders;

 -- WINDOW FRAMES
 select
    orderID,
    orderdate,
    orderstatus,
    sales,
    sum(sales) OVER (PARTITION BY orderstatus ORDER BY orderdate ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) totalsales
FROM sales.Orders;
-----------------------------------------------------
 select
    orderID,
    orderdate,
    orderstatus,
    sales,
    sum(sales) OVER (PARTITION BY orderstatus ORDER BY orderdate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) totalsales
FROM sales.Orders;
-----------------------------------------------------
 select
    orderID,
    orderdate,
    orderstatus,
    sales,
    sum(sales) OVER (PARTITION BY orderstatus ORDER BY orderdate ROWS 2 PRECEDING) totalsales
FROM sales.Orders;

-----------------------------------------------------
select
    orderID,
    orderdate,
    orderstatus,
    sales,
    sum(sales) OVER (PARTITION BY orderstatus ORDER BY orderdate ROWS UNBOUNDED PRECEDING) totalsales
FROM sales.Orders;

-----------------------------------------------------
-- DEFAULT FRAME
select
    orderID,
    orderdate,
    orderstatus,
    sales,
    sum(sales) OVER (PARTITION BY orderstatus ORDER BY orderdate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) totalsales
FROM sales.Orders;


---- FIND THE TOTAL SALES FOR EACH ORDER STATUS, ONLY FOR TWO PRODUCTS 101 AND 102
SELECT 
    ORDERID,
    ORDERSTATUS,
    SUM(SALES) OVER(PARTITION BY ORDERSTATUS) TotalSales
FROM SALES.Orders
WHERE ProductID IN (101,102);

-- Rank customers based on their total sales
select 
    CustomerID,
    sum(sales) total_sales,
    rank () OVER(ORDER BY sum(sales) desc) rank
from sales.orders
GROUP BY CustomerID;

-- Find the total number of Orders
-- Find the total orders for each customers
-- Additionally provide details such orderID , orderDate
select
    orderID,
    orderdate,
    customerID,
    count(*) over(PARTITION BY customerID) ordersbycustomers, 
    count(*) OVER() totalorders
from Sales.Orders;

-- Find the total number of customers 
-- Find the total number of scores for the customers
-- Additionally provide all customers Details 
SELECT *,
count(*) over() totalcustomers,
count(1) over() totalcustomers,
count(score) over() Totlscores,
count(LastName) OVER() totallastname
from sales.customers;

-- Check whether the table 'orders' contains any duplicate rows?

SELECT
    orderID,
    COUNT(*) OVER(PARTITION BY orderID) CHECKPK
from sales.Orders;

-- Check whether the table 'orders' archive contains any duplicate rows?
select *
FROM (
    select
        orderID,
        count(*) OVER(PARTITION BY ORDERID) PKCHECK
    from sales.OrdersArchive
) t where PKCHECK > 1;

-- Find the total sales across all orders and the total sales for each product
-- Additionally, provide details such as order ID and order date.

select
    orderID,
    orderDate,
    sales,
    productID,
    sum(sales) over() totalSales,
    sum(sales) over(PARTITION BY ProductID) salesbyproductID
FROM Sales.Orders;

-- Find the percentage contribution of each product's sales to the total sales

select
orderID,
PRODUCTID,
sales,
sum(sales) OVER() total_sales,
round(cast(sales as float) / sum(sales) over () * 100 , 2) PercentageofTotal
from sales.Orders;

-- Find the average sales across all orders
-- And Find the average sales for each product
-- Additionally provide details such order Id , order date

SELECT
    orderID,
    orderdate,
    Sales,
    PRODUCTID,
    avg(sales) over() avgsales,
    avg(sales) over(PARTITION BY productid) avgsalesproduct
from sales.orders;

-- Find the average scores of customers
-- Additionally provide details such customerID and lastName

SELECT
    customerID,
    lastname,
    score,
    coalesce(score,0) customerscore,
    avg(score) over() avgscores,
    avg(coalesce(score,0)) over() avgscores2
from sales.Customers;

-- Find all orders where sales are higher than the averge sales across all orders
select *
FROM (
    select
        orderID,
        PRODUCTid,
        sales,
        avg(sales) over() avgsales
    from sales.Orders
) T
where sales > avgSales;

-- Find the highest and lowest sales of all orders
-- Find the highest and lowest sales for each product
-- Additionally provide details such order ID , orderdate

select 
    orderID,
    orderdate,
    sales,
    PRODUCTid,
    max(sales) over() highestsales,
    min(sales) over() lowestsales,
    max(sales) over(PARTITION BY productID) highestsales2,
    min(sales) over(PARTITION BY productID) lowestsales2
from Sales.Orders;

-- Show the employees who have the highest salaries
SELECT 
*
FROM (
    SELECT
        EmployeeID,
        FirstName,
        Salary,
        max(Salary) over() highestsalaries
    FROM sales.Employees
) tk
where salary = highestsalaries ;

-- calculate the deviation of each sale from both the min and max sales amounts.
select 
    orderID,
    orderdate,
    sales,
    PRODUCTid,
    max(sales) over() highestsales,
    min(sales) over() lowestsales,
    sales - min(sales) over() deviationMIN,
    max(sales) over() - Sales deviationMAX
FROM sales.Orders;

-- Calculate moving average of sales for each product over time [Running total / moving average over time]

select 
    orderID,
    ProductID,
    Sales,
    avg(sales) over(partition by productid) avg,
    avg(Sales) over(partition by productid ORDER BY orderdate) movingavg
from Sales.Orders;

-- Calculate moving average of sales for each product over time, including only the next order [Rolling Total / moving avg for next order]

select 
    orderID,
    ProductID,
    Sales,
    avg(sales) over(PARTITION BY productID) avg,
    avg(Sales) over(partition by productid ORDER BY orderdate) movingavg,
    avg(sales) over(partition by productID order by orderdate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) as Rollingavg
from Sales.Orders;


---     RANK WINDOW FUNC        ---
-- Rank(ROW_NUMBER),(Rank),(DENSE_RANK) the orders based on their sales from highest to lowest
select
    orderID,
    sales,
    ROW_NUMBER() OVER(ORDER BY sales DESC ) SalesRank_Row,
    RANK() OVER(order BY sales DESC) SalesRank_Rank,
    DENSE_RANK() OVER(order by sales DESC) SalesRank_DENSE
FROM Sales.orders;

-- Find the top highest sales for each product [TOP N ANALYSIS]
select * 
from (
    SELECT
        orderID,
        ProductID,
        sales,
        ROW_NUMBER() OVER(PARTITION BY productID ORDER BY sales DESC) ROW_NOSales
    FROM Sales.Orders) t
where ROW_NOSales = 1;

-- Find the lowest 2 customers based on their total sales
select * from
(
    SELECT
        CustomerID,
        sum(sales) TotalSales,
        ROW_NUMBER() over(order by sum(sales)) RankRowCustomers
    from sales.orders
    GROUP BY CustomerID
)t
where RankRowCustomers <=2;

-- Assign unique IDs to the rows of the 'Orders Archive' table
select
    ROW_NUMBER() OVER(order by orderID, orderdate) UniqueID,
    *
FROM sales.OrdersArchive;

-- Identify duplicate rows in the table 'Orders Archive' and return a clean result without any duplicates
select * from 
(    select
        ROW_NUMBER() OVER(PARTITION BY orderID ORDER BY creationTime DESC) rn,
        *
    FROM Sales.OrdersArchive
) T
WHERE rn > 1;

-- Ntile
SELECT
    orderID,
    sales,
    NTILE(1) OVER(ORDER BY sales DESC) ONEBUCKET,
    NTILE(2) OVER(ORDER BY sales DESC) TWOBUCKET,
    NTILE(3) OVER(ORDER BY sales DESC) THREEBUCKET,
    NTILE(4) OVER(ORDER BY sales DESC) FOURBUCKET
FROM sales.orders;

--- Segment all orders into 3 categories : high , medium and low sales

select orderID, sales, 
CASE   
    WHEN buckets = 1 THEN 'HIGH'
    WHEN buckets = 2 THEN 'Medium'
    Else 'low'
END category
from (
select orderID, sales, NTILE(3) OVER(ORDER BY sales DESC) buckets
from Sales.Orders) t

-- Find the products that fall within the highest 40% of the prices
select *,
CONCAT(distRank * 100, '%') DistRankPerc 
from (
SELECT
    PRODUCT,
    price,
    CUME_DIST() OVER(ORDER BY price desc) distRank
    FROM sales.Products
) t
where distRank <=0.4;

-- Analyze the month-over-month performance by finding the percentage change
-- in sales between the current and previous month
select *,
    (currentsales - PreviousMonthSales)  as MOMChange,
    ROUND(CAST((currentsales - PreviousMonthSales) As FLOAT)/PreviousMonthSales * 100,1)  as percentageChange
from (
    select
        month(orderdate) OrderMonth,
        sum(sales) currentsales,
        lag(sum(sales)) over(order BY Month(orderdate)) PreviousMonthSales
    FROM Sales.Orders
    GROUP by Month(orderdate)
) t1


-- In order to analyze customer loyalty,
-- rank customers based on the average days between their orders
select
customerID,
avg(DaysUntilNextOrder) avgDays,
rank() OVER(ORDER BY coalesce(avg(DaysUntilNextOrder),9999999999999)) rankavg
from (    
    select
        OrderID,
        CustomerID,
        OrderDate currentOrder,
        LEAD(OrderDate) OVER(PARTITION BY customerID ORDER BY orderdate) NextOrder,
        DATEDIFF(day,orderdate,LEAD(OrderDate) OVER(PARTITION BY customerID ORDER BY orderdate)) DaysUntilNextOrder
    from Sales.Orders
) t1
group by CustomerID;

-- Find the lowest and Highest sales for each product
SELECT
    orderID,
    PRODUCTID,
    Sales,
    FIRST_VALUE(sales) OVER (PARTITION BY productID ORDER BY sales) lowestsales,
    LAST_VALUE(sales) OVER(PARTITION BY productID ORDER BY sales ROWS BETWEEN CURRENT ROW and UNBOUNDED FOLLOWING) highestsales,
    FIRST_VALUE(sales) OVER(PARTITION BY productID order BY sales desc) highestsales1,
    Min(sales) OVER (PARTITION BY productID) lowestsales1,
    Max(sales) OVER (PARTITION BY productID) Highestsales2
FROM Sales.Orders;

-- Sales Difference

SELECT
    orderID,
    PRODUCTID,
    Sales,
    FIRST_VALUE(sales) OVER (PARTITION BY productID ORDER BY sales) lowestsales,
    LAST_VALUE(sales) OVER(PARTITION BY productID ORDER BY sales ROWS BETWEEN CURRENT ROW and UNBOUNDED FOLLOWING) highestsales,
    Sales - FIRST_VALUE(sales) OVER (PARTITION BY productID ORDER BY sales) AS SalesDiff
FROM Sales.Orders;


---     SUB QUERIES     ---
-- Find the products that have a price higher than the average price of all products
select 
* from 
(
    select 
        productid,
        price,
        avg(price) over() avgprice
    from Sales.Products
) ta
where price > avgprice;

-- Rank customers based on their total amount of sales
select
    *,
    rank() over(order by totalsales desc) SalesRank
from
(
    select 
        customerID,
        sum(sales) as totalSales
    from sales.Orders
    group by customerID
) tr;

-- Show the product IDs, product names, prices, and the total number of orders

select 
    productid,
    product,
    price,
    (select count(*) from sales.orders) as TotalOrders
from sales.Products
group by     
productid,
    product,
    price;

-- show all customer details and find the total orders for each customers
select c.*, o.totalorders
from sales.Customers c left join 
    (select CustomerID , count(*) totalorders from sales.orders group by CustomerID)
     o on c.CustomerID=o.CustomerID

-- Find the products that have a price higher than the average price of all products
select *
from sales.Products
where price > (select avg(price) from sales.Products )

-- Show the details of orders made by customers in Germany & USA
select *
from sales.Orders
where customerID IN (
select customerID
from sales.Customers
where Country IN ('Germany','USA'));

-- Show the details of orders made by customers NOT in Germany
select *
from sales.Orders
where customerID IN (
select customerID
from sales.Customers
where Country NOT IN ('Germany'));

-- Find female employees whose salaries are greater than the salaries of any male employees
select 
* 
from sales.Employees
where Gender = 'F'
AND salary > ANY (SELECT salary FROM sales.Employees where Gender = 'M') ;

-- Find female employees whose salaries are greater than the salaries of all male employees
select *
from sales.Employees
where gender = 'F'
AND salary > ALL (SELECT salary from sales.Employees where Gender = 'M');

-- show all customer details and find the total orders of each customers
select 
    *,
    (SELECT COUNT(*) FROM sales.orders o where o.CustomerID = c.CustomerID) Totalsales
from sales.Customers c


-- Show the details of orders made by customers in Germany

select *
from sales.Orders o
where EXISTS ( select 1 FROM sales.customers c where country = 'Germany' AND o.CustomerID = c.CustomerID);



---     CTE's   ---
-- Step 1: Find the total sales per customer
with CTE_TotalSales as (
select
    customerID,
    sum(sales) as totalsales
from sales.Orders
GROUP BY CustomerID
),
-- Step2: Find the last order date for each customer
CTE_lastorderdate as (
select
customerID,
max(orderdate) latest_orderdate
from sales.Orders
group by customerID
),
-- Step3: Rank Customers based on total sales per customer (Nested CTE)
CTE_RankSales as (
select 
    customerid,
    RANK() OVER(order by totalsales desc) as salesrank
from CTE_TotalSales
),
--Step4 : Segment customers based on their total sales (Nested CTE)
CTE_Customer_segments AS (
    select
    customerID,
    totalsales,
    CASE 
        WHEN totalsales > 100 THEN 'HIGH'
        WHEN totalsales > 80 THEN 'MEDIUM'
        ELSE 'LOW'
    END customer_segment
    FROM CTE_TotalSales
)
-- Main Query
select
c.customerid,
c.FirstName,
coalesce(ctt.totalsales,0) as totalsales,
coalesce(latest_orderdate,null) as latestorderdate,
coalesce(salesrank,0) as salesrank,
customer_segment
FROM sales.Customers c LEFT JOIN CTE_TotalSales ctt ON c.CustomerID = ctt.CustomerID
LEFT JOIN CTE_lastorderdate ct1 on c.CustomerID = ct1.CustomerID
LEFT JOIN CTE_RankSales crs on c.CustomerID = crs.customerid
LEFT JOIN CTE_Customer_segments ccs on c.CustomerID = ccs.CustomerID
order by salesrank desc;


--- Resursive CTE's ---
--Generate a sequence of Numbers from 1 to 20
with series as (
    -- Anchor Query
    SELECT
    1 AS MyNumber
    UNION ALL
    -- Recursive Query
    SELECT
    MyNumber + 1
    FROM series
    where MyNumber < 2000
)
-- Main Query
SELECT *
FROM SERIES
OPTION (MAXRECURION 100000)


-- Show the employee hierarchy by displaying each employees's level within the organization
--Anchor Query
WITH CTE_emp_hi as
(
    select
        EmployeeID,
        FirstName,
        ManagerID,
        1 as LEVEL
    FROM sales.Employees
    where ManagerID IS NULL
    UNION ALL
    -- Recursive Query
    SELECT
    e.employeeID,
    e.FirstName,
    e.managerID,
    LEVEL + 1
    FROM sales.Employees as e
    INNER JOIN CTE_emp_hi  ceh
    ON e.EmployeeID = ceh.EmployeeID
)
--Main Query
SELECT * FROM CTE_emp_hi;

--- VIEW's  ---
-- Find the running total of sales for each month
with cte_monthlysummary as (
select
    orderdate,
    sum(sales) totalsales,
    count(orderid) totalorders,
    sum(quantity) totalquantitie
from sales.orders
group by orderdate
)
select
orderdate,
totalsales,
sum(totalsales) over(order by orderdate) as runningtotal
from cte_monthlysummary;

-- Create a view
create view sales.V_monthly_summary as 
(
    select
    orderdate,
    sum(sales) totalsales,
    count(orderid) totalorders,
    sum(quantity) totalquantitie
from sales.orders
group by orderdate
);

select * from sales.V_monthly_summary;

select
orderdate,
totalsales,
sum(totalsales) over(order by orderdate) as runningtotal
from sales.V_monthly_summary;

drop view sales.V_monthly_summary;

-- Provide view that combines details from orders, products, customers, and employees
CREATE VIEW sales.v_order_details as (
select
o.orderid,
o.orderDate,
p.product,
p.category,
coalesce(c.firstname,'')+' '+ coalesce(c.lastname,'') customername,
c.country customercountry,
coalesce(e.firstname,'')+' '+ coalesce(e.lastname,'') salesname,
e.department,
o.quantity
from sales.orders o
left join sales.products p
on p.ProductID = o.ProductID
left join sales.Customers c
on c.CustomerID = o.CustomerID
left join sales.Employees e
on e.EmployeeID = o.SalesPersonID
);

select * from sales.v_order_details;

-- Provide a view for EU sales Team
-- that combines details from all tables
-- And excludes data related to the USA
CREATE VIEW sales.EU_sales_Team as (
select
o.orderid,
o.orderDate,
p.product,
p.category,
coalesce(c.firstname,'')+' '+ coalesce(c.lastname,'') customername,
c.country customercountry,
coalesce(e.firstname,'')+' '+ coalesce(e.lastname,'') salesname,
e.department,
o.quantity
from sales.orders o
left join sales.products p
on p.ProductID = o.ProductID
left join sales.Customers c
on c.CustomerID = o.CustomerID
left join sales.Employees e
on e.EmployeeID = o.SalesPersonID
where c.country != 'USA'
);

select * from sales.EU_sales_Team;