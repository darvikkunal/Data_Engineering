-- PART TO WHOLE ---
-- which categories contribute the most to overall sales?
with category_sales as (
    select
        category,
        sum(sales_amount) total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
    GROUP BY 1
)

SELECT
    category,
    total_sales,
    sum(total_sales) OVER() overall_sales,
    CONCAT(ROUND((total_sales::int/ sum(total_sales) OVER()) * 100,2), '%') as percent_of_total
FROM category_sales
ORDER BY 2 desc;

-- DATA SEGMENTATION
-- Segment products into cost ranges and count how many products fall into each segment

with product_segments as (
    select Product_key,
    product_name,
    cost,
    CASE WHEN cost < 100 THEN 'BELOW 100'
    WHEN cost BETWEEN 100 AND 500 THEN '100-500'
    WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
    ELSE 'Above 1000'
END cost_range
FROM gold.dim_products)

select
    cost_range,
    COUNT(product_key) as total_products
    FROM product_segments
GROUP BY 1
ORDER BY 2 DESC;


/*Group customers into three segments based on their spending behavior:

- VIP: Customers with at least 12 months of history and spending more than €5,000.

- Regular: Customers with at least 12 months of history but spending €5,000 or less.

- New: Customers with a lifespan less than 12 months.

And find the total number of customers by each group
*/
WIth customer_spending as(
SELECT
    c.customer_key,
    SUM(f.sales_amount) AS total_spending,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12 +
    DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)

select 
    customer_segment,
    count(customer_key) total_customers
    FROM (
        select
        customer_key,
    CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
    ELSE 'New'
END customer_segment
FROM customer_spending) t
GROUP BY 1
ORDER BY 2 desc;


---- REPORTING

/*
Customer Report
========
Purpose:
- This report consolidates key customer metrics and behaviors
Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
- total orders
- total sales
- total quantity purchased
- total products
- lifespan (in months)
4. Calculates valuable KPIs:
- recency (months since last order)
- average order value
- average monthly spend
*/

-----
-- BASE QUERY
-----
with base_query as (
select
    f. order_number,
    f. product_key,
    f.order_date,
    f. sales_amount,
    f. quantity,
    c. customer_key,
    c. customer_number,
    concat(c. first_name, ' ',c. last_name) as customer_name,
    DATE_PART('YEAR',AGE(CURRENT_DATE,c.birthdate)) age 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
where f.order_date IS NOT NULL
),

select
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT (DISTINCT order_number) AS total_orders,
    SUM(sales_amount) As total_sales, SUM(quantity) AS total_quantity,
    COUNT (DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS lifespan
FROM base_query
GROUP BY 1,2,3,4;