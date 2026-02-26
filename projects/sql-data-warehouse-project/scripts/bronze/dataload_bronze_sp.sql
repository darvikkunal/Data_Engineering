\pset pager off

\echo ============================================================
\echo Loading Bronze Layer
\echo ============================================================

SELECT clock_timestamp() AS batch_start_time \gset

-- ============================
-- CRM TABLES
-- ============================
\echo ------------------------------------------------------------
\echo Loading CRM Tables
\echo ------------------------------------------------------------

SELECT clock_timestamp() AS start_time \gset
TRUNCATE TABLE bronze.crm_cust_info;
\copy bronze.crm_cust_info FROM '/Users/darvikkunalbanda/Data_Engineering/projects/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' WITH (FORMAT csv, HEADER true);
SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp)) AS crm_cust_info_load_seconds;
SELECT * FROM bronze.crm_cust_info LIMIT 5;

SELECT clock_timestamp() AS start_time \gset
TRUNCATE TABLE bronze.crm_prd_info;
\copy bronze.crm_prd_info FROM '/Users/darvikkunalbanda/Data_Engineering/projects/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' WITH (FORMAT csv, HEADER true);
SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp)) AS crm_prd_info_load_seconds;
SELECT * FROM bronze.crm_prd_info LIMIT 5;

SELECT clock_timestamp() AS start_time \gset
TRUNCATE TABLE bronze.crm_sales_details;
\copy bronze.crm_sales_details FROM '/Users/darvikkunalbanda/Data_Engineering/projects/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' WITH (FORMAT csv, HEADER true);
SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp)) AS crm_sales_details_load_seconds;
SELECT * FROM bronze.crm_sales_details LIMIT 5;

-- ============================
-- ERP TABLES
-- ============================
\echo ------------------------------------------------------------
\echo Loading ERP Tables
\echo ------------------------------------------------------------

SELECT clock_timestamp() AS start_time \gset
TRUNCATE TABLE bronze.erp_loc_a101;
\copy bronze.erp_loc_a101 FROM '/Users/darvikkunalbanda/Data_Engineering/projects/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv' WITH (FORMAT csv, HEADER true);
SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp)) AS erp_loc_a101_load_seconds;
SELECT * FROM bronze.erp_loc_a101 LIMIT 5;

SELECT clock_timestamp() AS start_time \gset
TRUNCATE TABLE bronze.erp_cust_az12;
\copy bronze.erp_cust_az12 FROM '/Users/darvikkunalbanda/Data_Engineering/projects/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' WITH (FORMAT csv, HEADER true);
SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp)) AS erp_cust_az12_load_seconds;
SELECT * FROM bronze.erp_cust_az12 LIMIT 5;

SELECT clock_timestamp() AS start_time \gset
TRUNCATE TABLE bronze.erp_px_cat_g1v2;
\copy bronze.erp_px_cat_g1v2 FROM '/Users/darvikkunalbanda/Data_Engineering/projects/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv' WITH (FORMAT csv, HEADER true);
SELECT clock_timestamp() AS end_time \gset
SELECT EXTRACT(EPOCH FROM (:'end_time'::timestamp - :'start_time'::timestamp)) AS erp_px_cat_g1v2_load_seconds;
SELECT * FROM bronze.erp_px_cat_g1v2 LIMIT 5;

SELECT clock_timestamp() AS batch_end_time \gset
SELECT EXTRACT(EPOCH FROM (:'batch_end_time'::timestamp - :'batch_start_time'::timestamp)) AS total_load_seconds;