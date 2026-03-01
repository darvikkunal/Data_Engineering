-----------------------------
-- For crm_cust_info
-----------------------------
-- Removing duplicates from cst_id , UNWANTED spaces
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
select 
    cst_id,
    cst_key,
    TRIM(cst_firstname) as cst_firstname,
    TRIM(cst_lastname) as cst_lastname,
    CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN  UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END cst_marital_status, -- Normalize marital status values to readable format
    CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'other'
    END cst_gndr, --Normalize gender values to readable format
    cst_create_date
from
    (select
        *,
        ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
    from bronze.crm_cust_info) t
where flag_last = 1 ;   -- select the most recent record per customer


-----------------------------
-- For crm_prd_info
-----------------------------
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
select
    prd_id,
    REPLACE(substr(prd_key,1,5),'-','_') AS cat_id, --Extract category ID
    SUBSTRING(prd_key,7, LENGTH(prd_key)) AS prd_key, --Extract product key
    prd_nm,
    COALESCE(prd_cost,0) as prd_cost,
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,  --Map product line codes to descriptive values
    CAST(prd_start_dt AS DATE) AS prd_start_dt,
    CAST(LEAD(prd_start_dt) OVER 
    (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS DATE) AS prd_end_dt -- Calculate end date as one day before the next start date
from bronze.crm_prd_info

-----------------------------
-- For crm_sales_details
-----------------------------
INSERT INTO silver.crm_sales_details(
    sls_ord_num,
    sls_prd_key,        
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales, 
    sls_quantity,
    sls_price
)
select  
    sls_ord_num,
    sls_prd_key, 
    sls_cust_id,
    CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
        ELSE TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
    END AS sls_order_dt, 
    CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
        ELSE TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')
    END AS sls_ship_dt, 
    CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
        ELSE TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')
    END AS sls_due_dt,
    sls_quantity,
    CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(COALESCE(sls_price, 0))
        THEN sls_quantity * ABS(COALESCE(sls_price, 0))
        ELSE sls_sales
    END AS sls_sales,
    CASE WHEN sls_price IS NULL OR sls_price <= 0
        THEN CASE WHEN sls_quantity > 0 THEN sls_sales / sls_quantity ELSE 0 END
        ELSE sls_price
    END AS sls_price
from bronze.crm_sales_details;