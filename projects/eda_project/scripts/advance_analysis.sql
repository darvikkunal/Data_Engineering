-- CHANGE OVER TIME ANALYSIS
-- Analyze Sales Performance over time

--OPTION1 EXTRACT
SELECT 
    EXTRACT(YEAR FROM ORDER_DATE) AS order_year,
    EXTRACT(MONTH FROM ORDER_DATE) AS order_month,
    SUM(SALES_AMOUNT) AS total_sales,
    COUNT(DISTINCT CUSTOMER_KEY) AS TOTAL_CUSTOMERS,
    SUM(QUANTITY) AS total_QUANTITY
FROM GOLD.FACT_SALES
WHERE ORDER_DATE IS NOT NULL
GROUP BY 1,2
ORDER BY 1,2;

--OPTION2 DATE_TRUNC
SELECT 
    DATE_TRUNC('month', ORDER_DATE) AS order_month,
    SUM(SALES_AMOUNT) AS total_sales,
    COUNT(DISTINCT CUSTOMER_KEY) AS TOTAL_CUSTOMERS,
    SUM(QUANTITY) AS total_QUANTITY
FROM GOLD.FACT_SALES
WHERE ORDER_DATE IS NOT NULL
GROUP BY 1
ORDER BY 1;

--OPTION3 TO_CHAR
SELECT 
    TO_CHAR(order_date, 'YYYY-Mon') AS order_month,
    SUM(SALES_AMOUNT) AS total_sales,
    COUNT(DISTINCT CUSTOMER_KEY) AS TOTAL_CUSTOMERS,
    SUM(QUANTITY) AS total_QUANTITY
FROM GOLD.FACT_SALES
WHERE ORDER_DATE IS NOT NULL
GROUP BY 1
ORDER BY 1;



-- CUMULATIVE ANALYSIS
-- Calculate the total sales per month and the running total of sales over time.
select 
    order_month,
    total_sales,
    sum(total_sales) OVER (PARTITION BY order_month ORDER BY order_month) AS running_total_sales,
    avg(avg_price) OVER (PARTITION BY order_month ORDER BY order_month) AS moving_avg_price
FROM
    (select
        DATE_TRUNC('month', order_date) AS order_month,
        sum(sales_amount) as total_sales,
        avg(price) as avg_price
    from gold.fact_sales
    where order_date is not null
    group by 1
    order by 2 desc) t


-- Performance Analysis
-- Analyze the yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales.

