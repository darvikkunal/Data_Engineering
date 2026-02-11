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