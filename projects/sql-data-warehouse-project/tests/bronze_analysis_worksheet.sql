-----------------------------
-- For crm_cust_info
-----------------------------

-- check for nulls or duplicates in Primary Key
-- Expectation : No Result
select 
    cst_id,
    count(*)
from bronze.crm_cust_info
GROUP BY cst_id
having count(*) > 1 OR cst_id is NULL;

-- check for unwanted spaces
-- Expectiation : No result
select cst_firstname , cst_lastname
from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname) or cst_lastname != TRIM(cst_lastname);

-- data standardization & consistency cst_gndr ,cst_marital_status
select DISTINCT cst_gndr
from bronze.crm_cust_info;

select DISTINCT cst_marital_status
from bronze.crm_cust_info;

-----------------------------
-- For crm_prd_info
-----------------------------

select * from bronze.crm_prd_info;

-- check for nulls or duplicates in Primary Key
-- Expectation : No Result

select 
    prd_id,
    count(*)
FROM bronze.crm_prd_info
group by prd_id
HAVING count(*) > 1 or prd_id is NULL;

-----------------------------
-- For crm_prd_info
-----------------------------
-- check for nulls or negative numbers
-- Expectation : No results
select prd_nm
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm);

select prd_cost
from bronze.crm_prd_info
where prd_cost <0 or prd_cost is null;

select distinct prd_line
from bronze.crm_prd_info;

-- working on prd_start_dt and prd_end_dt

select
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS prd_end_test
from bronze.crm_prd_info
where prd_key like 'AC-HE-HL%';


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
    NULLIF(sls_order_dt, 0) as sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 OR LENGTH(sls_order_dt::TEXT) != 8 OR sls_order_dt > 20500101; 

select *
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

select DISTINCT
sls_sales,
sls_quantity,
sls_price

 

from bronze.crm_sales_details
where sls_sales != sls_quantity IS NULL OR sls_price is NULL OR
sls_sales <0 OR sls_quantity <0 OR sls_price <0


SELECT DISTINCT
    sls_sales AS old_sls_sales,
    sls_quantity, 
    sls_price as old_sls_price,
    CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    CASE WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_quantity
        ELSE sls_price
    END AS sls_price
from bronze.crm_sales_details
where sls_sales IS NULL or sls_quantity IS NULL or sls_price IS NULL
    or sls_sales < 0 OR sls_quantity < 0 OR sls_price < 0;

-----------------------------
-- For erp_cust_az12
-- we are joining erp_cust_az12 with crm_cust_info
-----------------------------
select * from bronze.crm_cust_info limit 5;

select * from bronze.erp_cust_az12 limit 5;

select
    cid,
    case 
        when cid like 'NAS%' THEN SUBSTRING(cid FROM 4)
        else cid
    end cid,
    bdate,
    gen
from bronze.erp_cust_az12
where     case 
        when cid like 'NAS%' THEN SUBSTRING(cid FROM 4)
        else cid
    END NOT IN (select DISTINCT cst_key FROM silver.crm_cust_info)

select bdate from bronze.erp_cust_az12 
where bdate > current_date;

select distinct gen 
from bronze.erp_cust_az12;

select distinct gen,
case when UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
    when UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
    else 'n/a'
end gender
from bronze.erp_cust_az12;

-----------------------------
-- For erp_loc_a101
-----------------------------

select * , length(cst_key) from silver.crm_cust_info limit 5;

select * , length(cid) from bronze.erp_loc_a101 limit 5;

select cid,
    replace(cid,'-','') as new,
    length(replace(cid,'-',''))
from bronze.erp_loc_a101
where replace(cid,'-','') NOT IN
(SELECT cst_key FROM silver.crm_cust_info);

select distinct cntry
from bronze.erp_loc_a101;

-----------------------------
-- For erp_px_cat_g1v2
-----------------------------
select * from silver.crm_prd_info limit 5;

select *
from bronze.erp_px_cat_g1v2 limit 5;

-- check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
where cat != TRIM(cat) OR subcat !=(subcat)
OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
SELECT DISTINCT
cat 
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2;

