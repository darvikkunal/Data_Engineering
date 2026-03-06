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
CREATE VIEW gold.report_customers AS
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
--customer aggregations: Summarizes key metrics at the customer level
customer_aggregation as (
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
GROUP BY 1,2,3,4
)

SELECT
    customer_key, 
    customer_number, 
    customer_name, 
    age, 
CASE
    WHEN age < 20 THEN 'Under 20'
    WHEN age between 20 and 29 THEN '20-29'
    WHEN age between 30 and 39 THEN '30-39'
    WHEN age between 40 and 49 THEN '40-49'
    ELSE '50 and above'
    END AS age_group,
CASE
    WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP' 
    WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
    END AS customer_segment,
    last_order_date,
    DATE_PART('year', AGE(CURRENT_DATE, last_order_date)) * 12 +
    DATE_PART('month', AGE(CURRENT_DATE, last_order_date)) AS recency,
    total_orders,
    total_sales, 
    total_quantity, 
    total_products,
    lifespan,
    -- compute average order value (AVO)
    CASE WHEN total_sales = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_value,
    -- compute average monthly spend
    CASE WHEN lifespan = 0 THEN total_sales
    ELSE total_sales / lifespan
    END AS avg_monthly_spend
FROM customer_aggregation;



SELECT * from gold.report_customers;


/*
Product Report
===========
Purpose:
- This report consolidates key product metrics and behaviors.
Highlights:
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
- total orders
- total sales
- total quantity sold
- total customers (unique)
- lifespan (in months)
4. Calculates valuable KPIs:
- recency (months since last sale)
- average order revenue (AOR)
- average monthly revenue
*/

CREATE VIEW gold.report_products AS
WITH base_query AS (
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
),

product_aggregation AS (
    SELECT
        product_key,
        product_name,
        category,
        subcategory,
        cost,

        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan,

        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,

        ROUND(AVG(sales_amount / NULLIF(quantity,0)),1) AS avg_selling_price

    FROM base_query
    GROUP BY 1,2,3,4,5
)

SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,

    EXTRACT(YEAR FROM AGE(CURRENT_DATE, last_sale_date)) * 12 +
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_sale_date)) AS recency_in_months,

    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue

FROM product_aggregation;

select * from gold.report_products;