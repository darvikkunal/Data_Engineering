-- ================================================================
-- FACT table crm_sales_details [JOIN gold.dim_products on prd_key & product_number & gold.dim_customers on cust_id & customer_id] to get surrogate keys product_key & customer_key
-- And to create view gold.crm_sales_details 
-- ================================================================
CREATE VIEW gold.fact_sales AS
select 
    sd.sls_ord_num order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt order_date,
    sd.sls_ship_dt shipping_date,
    sd.sls_due_dt due_date,
    sd.sls_sales sales_amount,
    sd.sls_quantity quantity,
    sd.sls_price price
from silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;

--------------- CHECKING FACT TBL
select * from gold.fact_sales;


---- CHECKING ALL TBLE Foreign Key Integrity (Dimensions)

select * from gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE c.customer_key IS NULL;

