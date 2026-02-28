-----------------------------
-- For crm_cust_info
-----------------------------
-- QUALITY CHECK
-- check for nulls or duplicates in Primary Key
-- Expectation : No Result
select 
    cst_id,
    count(*)
from silver.crm_cust_info
GROUP BY cst_id
having count(*) > 1 OR cst_id is NULL;

-- check for unwanted spaces
-- Expectiation : No result
select cst_firstname , cst_lastname
from silver.crm_cust_info
where cst_firstname != TRIM(cst_firstname) or cst_lastname != TRIM(cst_lastname);

-- data standardization & consistency cst_gndr ,cst_marital_status
select DISTINCT cst_gndr
from silver.crm_cust_info;

select DISTINCT cst_marital_status
from silver.crm_cust_info;

select *
from silver.crm_cust_info;

-----------------------------
-- For crm_prd_info
-----------------------------
-- check for nulls or negative numbers
-- Expectation : No results
select prd_nm
from silver.crm_prd_info
where prd_nm != TRIM(prd_nm);

select prd_cost
from silver.crm_prd_info
where prd_cost <0 or prd_cost is null;

select distinct prd_line
from silver.crm_prd_info;

-- working on prd_start_dt and prd_end_dt

select
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS prd_end_test
from silver.crm_prd_info
where prd_key like 'AC-HE-HL%';

SELECT * from silver.crm_prd_info;

-----------------------------
-- For crm_sales_details
-----------------------------

select *
from bronze.crm_sales_details
where sls_ord_num != TRIM(sls_ord_num)

select *
from bronze.crm_sales_details
where sls_prd_key NOT IN (SELECT prd_key from silver.crm_prd_info)

select *
from bronze.crm_sales_details
where sls_cust_id NOT IN (SELECT cst_id from silver.crm_cust_info)

-- check for Invalid Dates

select
    sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0

select * from silver.crm_sales_details;
