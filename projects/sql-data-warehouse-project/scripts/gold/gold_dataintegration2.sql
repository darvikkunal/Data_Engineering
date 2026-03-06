-- ================================================================
-- JOINING crm_prod_info & erp_px_catg1v2 ON cst_key & cid. 
-- And to create view gold.dim_products
-- ================================================================
CREATE VIEW gold.dim_products AS

select
    ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key,
    pn.prd_id product_id,
    pn.prd_key product_number,
    pn.prd_nm product_name,
    pn.cat_id category_id,
    pc.cat category,
    pc.subcat subcategory,
    pc.maintenance,
    pn.prd_cost cost,
    pn.prd_line product_line,
    pn.prd_start_dt start_date
from silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
where prd_end_dt IS NULL; -- Filter out all historical data

-- ================================================================
-- prd_key is unique
select prd_key, COUNT(*) FRoM (
select
    pn.prd_id,
    pn.cat_id,
    pn.prd_key,
    pn.prd_nm,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt,
    pc.cat,
    pc.subcat,
    pc.maintenance
from silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
where prd_end_dt IS NULL -- Filter out all historical data
)t GROUP BY prd_key
HAVING COUNT(*) > 1

--------------
-- Testing gold.dim_products view

select * from gold.dim_products;

