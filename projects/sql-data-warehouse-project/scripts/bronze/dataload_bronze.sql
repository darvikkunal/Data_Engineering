-- ============================
-- Bronze Layer Data Load
-- ============================

TRUNCATE TABLE bronze.crm_cust_info;
\copy bronze.crm_cust_info FROM '/Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.crm_prd_info;
\copy bronze.crm_prd_info FROM '/Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.crm_sales_details;
\copy bronze.crm_sales_details FROM '/Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.erp_loc_a101;
\copy bronze.erp_loc_a101 FROM '/Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.erp_cust_az12;
\copy bronze.erp_cust_az12 FROM '/Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' WITH (FORMAT csv, HEADER true);

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
\copy bronze.erp_px_cat_g1v2 FROM '/Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv' WITH (FORMAT csv, HEADER true);

-- Testing the tables
select * from bronze.crm_cust_info limit 5;
select * from bronze.crm_prd_info limit 5;
select * from bronze.crm_sales_details limit 5;
select * from bronze.erp_loc_a101 limit 5;
select * from bronze.erp_cust_az12 limit 5;
select * from bronze.erp_px_cat_g1v2 limit 5;


SELECT COUNT(*) FROM bronze.crm_cust_info;
SELECT COUNT(*) FROM bronze.crm_prd_info;
SELECT COUNT(*) FROM bronze.crm_sales_details;
SELECT COUNT(*) FROM bronze.erp_loc_a101;
SELECT COUNT(*) FROM bronze.erp_cust_az12;
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;