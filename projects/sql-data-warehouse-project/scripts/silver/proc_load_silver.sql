/*
===============================================================================
Silver Layer Data Load (Bronze -> Silver) | PostgreSQL
===============================================================================
✔ No stored procedures
✔ SQL Server-style logging
✔ PostgreSQL-compliant transformations
✔ Execution timing
===============================================================================
*/

\pset pager off

\echo ============================================================
\echo Loading Silver Layer
\echo ============================================================

SELECT clock_timestamp() AS batch_start_time \gset

-- ================================================================
-- CRM TABLES
-- ================================================================
\echo ------------------------------------------------------------
\echo Loading CRM Tables
\echo ------------------------------------------------------------

-- ================================================================
-- silver.crm_cust_info
-- ================================================================
SELECT clock_timestamp() AS start_time \gset
\echo >> Truncating Table: silver.crm_cust_info
TRUNCATE TABLE silver.crm_cust_info;

\echo >> Inserting Data Into: silver.crm_cust_info
INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname),
    TRIM(cst_lastname),
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END,
    cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE rn = 1;

SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp))
       AS crm_cust_info_load_seconds;

\echo >> Preview (5 rows)
SELECT * FROM silver.crm_cust_info LIMIT 5;

-- ================================================================
-- silver.crm_prd_info
-- ================================================================
SELECT clock_timestamp() AS start_time \gset
\echo >> Truncating Table: silver.crm_prd_info
TRUNCATE TABLE silver.crm_prd_info;

\echo >> Inserting Data Into: silver.crm_prd_info
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
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key FROM 1 FOR 5), '-', '_'),
    SUBSTRING(prd_key FROM 7),
    prd_nm,
    COALESCE(prd_cost, 0),
    CASE
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END,
    prd_start_dt,
    (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day')::DATE
FROM bronze.crm_prd_info;

SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp))
       AS crm_prd_info_load_seconds;

\echo >> Preview (5 rows)
SELECT * FROM silver.crm_prd_info LIMIT 5;

-- ================================================================
-- silver.crm_sales_details
-- ================================================================
SELECT clock_timestamp() AS start_time \gset
\echo >> Truncating Table: silver.crm_sales_details
TRUNCATE TABLE silver.crm_sales_details;

\echo >> Inserting Data Into: silver.crm_sales_details
INSERT INTO silver.crm_sales_details (
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
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE WHEN sls_order_dt::TEXT ~ '^\d{8}$'
         THEN TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD') END,
    CASE WHEN sls_ship_dt::TEXT ~ '^\d{8}$'
         THEN TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD') END,
    CASE WHEN sls_due_dt::TEXT ~ '^\d{8}$'
         THEN TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD') END,
    CASE
        WHEN sls_sales IS NULL OR sls_sales <= 0
             OR sls_sales <> sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END,
    sls_quantity,
    CASE
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END
FROM bronze.crm_sales_details;

SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp))
       AS crm_sales_details_load_seconds;

\echo >> Preview (5 rows)
SELECT * FROM silver.crm_sales_details LIMIT 5;

-- ================================================================
-- ERP TABLES
-- ================================================================
\echo ------------------------------------------------------------
\echo Loading ERP Tables
\echo ------------------------------------------------------------

-- ================================================================
-- silver.erp_cust_az12
-- ================================================================
SELECT clock_timestamp() AS start_time \gset
\echo >> Truncating Table: silver.erp_cust_az12
TRUNCATE TABLE silver.erp_cust_az12;

INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid FROM 4) ELSE cid END,
    CASE WHEN bdate > CURRENT_DATE THEN NULL ELSE bdate END,
    CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END
FROM bronze.erp_cust_az12;

SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp))
       AS erp_cust_az12_load_seconds;

\echo >> Preview (5 rows)
SELECT * FROM silver.erp_cust_az12 LIMIT 5;

-- ================================================================
-- silver.erp_loc_a101
-- ================================================================
SELECT clock_timestamp() AS start_time \gset
\echo >> Truncating Table: silver.erp_loc_a101
TRUNCATE TABLE silver.erp_loc_a101;

INSERT INTO silver.erp_loc_a101 (
    cid,
    cntry
)
SELECT
    REPLACE(cid, '-', ''),
    CASE
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
        ELSE TRIM(cntry)
    END
FROM bronze.erp_loc_a101;

SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp))
       AS erp_loc_a101_load_seconds;

\echo >> Preview (5 rows)
SELECT * FROM silver.erp_loc_a101 LIMIT 5;

-- ================================================================
-- silver.erp_px_cat_g1v2
-- ================================================================
SELECT clock_timestamp() AS start_time \gset
\echo >> Truncating Table: silver.erp_px_cat_g1v2
TRUNCATE TABLE silver.erp_px_cat_g1v2;

INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp))
       AS erp_px_cat_g1v2_load_seconds;

\echo >> Preview (5 rows)
SELECT * FROM silver.erp_px_cat_g1v2 LIMIT 5;

-- ================================================================
-- Batch completion
-- ================================================================
SELECT clock_timestamp() AS batch_end_time \gset

\echo ============================================================
\echo Silver Layer Load Completed Successfully
SELECT EXTRACT(EPOCH FROM (:'batch_end_time'::timestamp - :'batch_start_time'::timestamp))
       AS total_load_seconds;
\echo ============================================================
