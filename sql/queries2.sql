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
