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


