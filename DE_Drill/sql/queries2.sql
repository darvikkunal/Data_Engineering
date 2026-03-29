/* 🗄️ SQL — Problem 13 — Hard**

> Using **multiple CTEs**, find the **top 3 customers by total revenue** in each country. Show `Country`, `CustomerID`, `CompanyName`, `total_revenue` and `country_rank`.

Tables needed: `orders`, `order_details`, `customers`

Hint — think in steps:
```
CTE 1 → calculate total revenue per order (order_details)
CTE 2 → join with orders to get CustomerID, then sum by customer
CTE 3 → join with customers to get CompanyName and Country
Final  → RANK() OVER (PARTITION BY Country) + QUALIFY
```
*/

with cte1 as (
    select
	    orderid,
	    round(sum(((od.UnitPrice * od.Quantity) * (1-od.Discount))),2) as order_revenue
    from order_details od
    group by 1
),
cte2 as (
select
	o.customerid,
	sum(cte1.order_revenue) as total_revenue
from cte1 cte1
JOIN ORDERS o on cte1.orderid = o.orderid
group by 1
),
cte3 as (
select
	c.customerid,
	c.companyname,
	c.country,
	cte2.total_revenue 
from cte2 cte2 JOIN customers c on cte2.customerid = c.customerid
)
select
	*,
	RANK() OVER(PARTITION BY country order by total_revenue DESC) AS country_rank
from cte3
QUALIFY country_rank <=3;


/**🗄️ SQL — Problem 14 — Hard**

> Using multiple CTEs, calculate for each employee:
> - Their `full_name`
> - `total_orders` handled
> - `total_revenue` generated
> - Their **revenue rank** among all employees
> - How much their revenue is **above or below the average** employee revenue (call it `vs_avg_revenue`)

Tables needed: `orders`, `order_details`, `employees`

Hint — think in steps:
```
CTE 1 → revenue per order line (order_details)
CTE 2 → total revenue + order count per employee
CTE 3 → join employees to get full name
Final  → RANK() + AVG() OVER () for vs_avg
*/

with cte1 as (
    select
	    orderid,
	    round(sum(((od.UnitPrice * od.Quantity) * (1-od.Discount))),2) as order_revenue
    from order_details od
    group by 1
),
cte2 as (
select 
	o.employeeid,
	count(o.orderid) as order_count,
	sum(order_revenue) as total_revenue
from cte1 ct1 join orders o on ct1.orderid = o.orderid
group by 1
),
cte3 as (
SELECT 
	ct2.*,
	concat(e.firstname, ' ' ,e.lastname) as employee_fullname
FROM cte2 ct2 JOIN employees e on ct2.employeeid = e.employeeid
)
select 
	*,
	RANK() OVER(ORDER BY total_revenue desc) as revenue_rank,
	ROUND(total_revenue - AVG(total_revenue) OVER(), 2) AS vs_avg_revenue
FROM cte3;


/*
SQL — Problem 15 — Medium

Using CASE WHEN, categorise all products into price buckets:

'Budget' → UnitPrice < 20
'Mid Range' → UnitPrice between 20 and 50
'Premium' → UnitPrice > 50

Show ProductName, UnitPrice and price_category. Sort by UnitPrice highest to lowest.

Tables needed: products
*/

select
	productID,
	ProductName,
	Unitprice,
CASE
	WHEN unitPrice < 20 THEN 'Budget'
	WHEN UnitPrice between 20 and 50 THEN 'Mid Range'
	WHEN UnitPrice > 50 THEN 'Premium'
	END as price_bucket
from products
order by Unitprice DESC;




/*
 SQL — Problem 16 — Medium/Hard

For each order, show:

OrderID
OrderDate
ShippedDate
Number of days taken to ship the order as days_to_ship
A shipping_status column using CASE WHEN:

'On Time' → shipped within 7 days
'Delayed' → took more than 7 days
'Not Shipped' → ShippedDate is NULL



Only show orders from 1997. Sort by days_to_ship highest to lowest.

Tables needed: orders
Hint: Use DATEDIFF('day', OrderDate, ShippedDate) to calculate days between two dates.
*/

select
OrderID,
OrderDate,
ShippedDate,
DATEDIFF('day', orderDate, CAST(ShippedDate AS DATE)) as days_to_ship,
CASE
    WHEN ShippedDate IS NULL THEN 'NOT SHIPPED'
	WHEN days_to_ship <= 7 THEN 'ON TIME'
	WHEN days_to_ship > 7 THEN 'DELAYED'
END as shipping_status
FROM orders
WHERE YEAR(OrderDate) = 1997
ORDER BY days_to_ship desc;


/*
SQL — Problem 17 — Medium
Using string functions, clean and transform customer data:

CustomerID
CompanyName in UPPER CASE as company_upper
ContactName — first name only (before the space) as first_name
Phone — length of phone number as phone_length
Country — replace 'UK' with 'United Kingdom' as country_clean

Sort by CompanyName A→Z. Table: customers
*/

select
	customerid,
	UPPER(companyName) as company_upper,
	SPLIT_PART(contactName , ' ',1) as first_name,
	length(phone) as phone_length,
	replace(country,'UK','United Kingdom') as country_clean
from customers
order by companyName asc;



/*
SQL — Problem 18 — Hard
Recursive CTE to show the employee hierarchy:

EmployeeID, full_name, Title
ManagerName (full name of who they report to)
level — 1 for top manager, 2 for direct reports, 3 for next level down

Table: employees
*/

with RECURSIVE hierarchy as (
	select
		employeeid,
		concat(firstname,' ',lastname) as empfullname,
		title,
		CAST(NULL AS VARCHAR) AS ManagerName,
		1 AS level
	from employees
	where ReportsTo = 'NULL'
	
	UNION ALL
	
	SELECT 
		e.employeeID,
		concat(e.firstname,' ',e.lastname) as empfullname,
		e.title,
		h.empfullname as ManagerName,
		h.level + 1
	FROM employees e
	JOIN hierarchy h on e.reportsto = CAST(h.employeeid AS VARCHAR)
)
SELECT * from hierarchy
ORDER BY level, employeeID;