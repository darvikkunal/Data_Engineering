-- Finding Duplicates in Primary Key

select cst_id, COUNT(*) FROM
   (select
    ci.cst_id,
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    ci.cst_marital_status,
    ci.cst_gndr,
    ci.cst_create_date,
    ca.bdate,
    ca.gen,
    la.cntry
from silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid
)t GROUP BY cst_id
HAVING COUNT(*) > 1 

--- Data Integration for ci.cst_gndr & ca.gen

select DISTINCT
    ci.cst_gndr,
    ca.gen,
    CASE WHEN ci.cst_gndr != 'other' THEN ci.cst_gndr -- CRN is the Master for gender Info
        ELSE COALESCE(ca.gen, 'n/a')
    END AS new_gen
from silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid
ORDER BY 1,2

-- ================================================================
-- JOINING crm_cust_info & erp_cust_az12 ON cst_key & cid. 
-- JOINING crm_cust_info & erp_loc_a101 ON cst_key & cid. 
-- And to create view gold.dim_customers
-- ================================================================
CREATE VIEW gold.dim_customers AS
select
    row_number() OVER(ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id customer_id,
    ci.cst_key customer_number,
    ci.cst_firstname first_name,
    ci.cst_lastname last_name,
    la.cntry country,
    ci.cst_marital_status martial_status,
    CASE WHEN ci.cst_gndr != 'other' THEN ci.cst_gndr -- CRN is the Master for gender Info
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ca.bdate birthdate,
    ci.cst_create_date create_date
from silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;


-------- CHECKING thE VIEW

select * from gold.dim_customers;
select distinct gender from gold.dim_customers;