# Silver Layer Load (Bronze → Silver) — PostgreSQL

This document explains how the Silver layer is built and loaded from the Bronze layer in PostgreSQL, including transformations, joins, new columns, and execution steps.

**The Silver layer represents cleaned, standardized, analytics-ready data.**

---

## Table of Contents

1. [Objective of the Silver Layer](#1-objective-of-the-silver-layer)
2. [Source Systems Overview](#2-source-systems-overview-crm--erp)
3. [Entity Relationships](#3-entity-relationships-from-diagram)
4. [proc_load_silver.sql Structure](#4-how-proc_load_silversql-is-structured)
5. [New Columns in Silver Layer](#5-new-columns-added-in-silver-layer)
6. [Silver Transformations](#6-silver-transformations-table-by-table)
7. [Executing the Silver Load](#7-executing-the-silver-load)
8. [Verified Execution Output](#8-verified-execution-output)
9. [Why This Approach Works](#9-why-this-approach-is-correct-in-postgresql)
10. [Next Steps](#10-next-steps)
11. [Silver Layer Data Preview](#11-silver-layer-data-preview-first-5-rows)

---


## 1. Objective of the Silver Layer

The Silver layer sits between raw Bronze data and business-facing Gold models.

**Its purpose is to:**

- Clean and standardize data
- Deduplicate records
- Normalize codes into readable values
- Fix invalid dates and measures
- Add audit metadata (`dwh_create_date`)
- Prepare data for joins across CRM and ERP domains

---

## 2. Source Systems Overview (CRM & ERP)

### CRM (Customer Relationship Management)

| Table | Purpose |
|-------|---------|
| `bronze.crm_cust_info` | Customer master data |
| `bronze.crm_prd_info` | Current & historical product info |
| `bronze.crm_sales_details` | Transactional sales records |

### ERP (Enterprise Resource Planning)

| Table | Purpose |
|-------|---------|
| `bronze.erp_cust_az12` | Customer birthdate & gender |
| `bronze.erp_loc_a101` | Customer country |
| `bronze.erp_px_cat_g1v2` | Product category hierarchy |

---

## 3. Entity Relationships (from Diagram)

### Key Relationships

| From | To | Join Key |
|------|----|----|
| `crm_sales_details` | → `crm_prd_info` | `prd_key` |
| `crm_sales_details` | → `crm_cust_info` | `cst_id` |
| `crm_cust_info` | → `erp_cust_az12` | `cst_key = cid` |
| `crm_cust_info` | → `erp_loc_a101` | `cst_key = cid` |
| `crm_prd_info` | → `erp_px_cat_g1v2` | `cat_id = id` |

---

## 4. How proc_load_silver.sql Is Structured

> **Note:** This is **NOT** a stored procedure. It is a `psql` execution script with logging, timing, and previews.

### High-level Flow

1. Disable pager
2. Capture batch start time
3. Load CRM Silver tables
4. Load ERP Silver tables
5. Print execution times
6. Preview 5 rows per table
7. Print total load duration

---

## 5. New Columns Added in Silver Layer

### `dwh_create_date`

Added to every Silver table:

```sql
dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
```

**Purpose:**
- Load audit tracking
- Incremental load support later
- Data freshness visibility

---

## 6. Silver Transformations (Table-by-Table)

### 6.1 silver.crm_cust_info

**Source:** `bronze.crm_cust_info`

#### Transformations Applied

- Trim names
- Deduplicate customers using latest `cst_create_date`
- Normalize marital status:
  - `S` → Single
  - `M` → Married
- Normalize gender:
  - `F` → Female
  - `M` → Male
- Add `dwh_create_date`

#### Deduplication Logic

```sql
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC)
```

**Only the latest record per customer is retained.**

---

### 6.2 silver.crm_prd_info

**Source:** `bronze.crm_prd_info`

#### Transformations Applied

- Extract `cat_id` from `prd_key`
- Normalize product line codes:
  - `M` → Mountain
  - `R` → Road
  - `S` → Other Sales
  - `T` → Touring
- Replace null product cost with `0`
- Calculate `prd_end_dt` using window function
- Add `dwh_create_date`

---

### 6.3 silver.crm_sales_details

**Source:** `bronze.crm_sales_details`

#### Transformations Applied

- Convert invalid date integers to `NULL`
- Recalculate `sls_sales` if incorrect
- Derive `sls_price` when missing
- Preserve clean transactional grain
- Add `dwh_create_date`

**This table remains fact-like, not aggregated.**

---

### 6.4 silver.erp_cust_az12

**Source:** `bronze.erp_cust_az12`

#### Transformations Applied

- Remove `NAS` prefix from `cid`
- Replace future birthdates with `NULL`
- Normalize gender values
- Add `dwh_create_date`

---

### 6.5 silver.erp_loc_a101

**Source:** `bronze.erp_loc_a101`

#### Transformations Applied

- Remove hyphens from `cid`
- Normalize country codes:
  - `DE` → Germany
  - `US` / `USA` → United States
  - Handle blanks and nulls
- Add `dwh_create_date`

---

### 6.6 silver.erp_px_cat_g1v2

**Source:** `bronze.erp_px_cat_g1v2`

#### Transformations Applied

- Direct load (already clean)
- Add `dwh_create_date`

---

## 7. Executing the Silver Load

### Terminal Commands

```bash
psql -h localhost -p 5432 -U postgres -d dwh
```

Inside `psql`:

```sql
\i /Users/darvikkunalbanda/DataEngineering/projects/sql-data-warehouse-project/scripts/silver/proc_load_silver.sql
```

---

## 8. Verified Execution Output

✅ Tables truncated  
✅ Rows inserted  
✅ Timings logged  
✅ 5-row previews displayed  
✅ Total load time reported  

### Example Output

```
Silver Layer Load Completed Successfully
total_load_seconds
--------------------
0.340262
```

---

## 9. Why This Approach Is Correct in PostgreSQL

PostgreSQL **cannot read local files inside stored procedures**.

`psql` scripts allow:
- Logging (`\echo`)
- Variable timing (`\gset`)
- Previews
- File execution (`\i`)

**This mirrors production ETL orchestration patterns (Python / Airflow).**

---

## 10. Next Steps

- Build Gold dimensions & facts
- Introduce surrogate keys
- Add data quality checks
- Move orchestration to Python / Airflow
- Add incremental loading logic

---

## 11. Silver Layer Data Preview (First 5 Rows)

After loading each Silver table, a 5-row preview is displayed to immediately validate:

- Data correctness
- Transformations
- Normalized values
- Audit column population

**This avoids dumping entire tables and keeps logs readable.**

---

### 11.1 silver.crm_cust_info — Customer Master

```
 cst_id |  cst_key   | cst_firstname | cst_lastname | cst_marital_status | cst_gndr | cst_create_date |      dwh_create_date
--------+------------+---------------+--------------+--------------------+----------+-----------------+----------------------------
 11000  | AW00011000 | Jon           | Yang         | Married            | Male     | 2025-10-06      | 2026-02-27 11:02:52.291319
 11001  | AW00011001 | Eugene        | Huang        | Single             | Male     | 2025-10-06      | 2026-02-27 11:02:52.291319
 11002  | AW00011002 | Ruben         | Torres       | Married            | Male     | 2025-10-06      | 2026-02-27 11:02:52.291319
 11003  | AW00011003 | Christy       | Zhu          | Single             | Female   | 2025-10-06      | 2026-02-27 11:02:52.291319
 11004  | AW00011004 | Elizabeth     | Johnson      | Single             | Female   | 2025-10-06      | 2026-02-27 11:02:52.291319
```

✅ Deduplicated  
✅ Gender & marital status normalized  
✅ Audit timestamp added

---

### 11.2 silver.crm_prd_info — Product Master

```
 prd_id | cat_id | prd_key |         prd_nm         | prd_cost |  prd_line   | prd_start_dt | prd_end_dt |      dwh_create_date
--------+--------+---------+------------------------+----------+-------------+--------------+------------+----------------------------
   478  | AC_BC  | BC-M005 | Mountain Bottle Cage   |        4 | Mountain    | 2013-07-01   |            | 2026-02-27 11:02:52.364839
   479  | AC_BC  | BC-R205 | Road Bottle Cage       |        3 | Road        | 2013-07-01   |            | 2026-02-27 11:02:52.364839
   477  | AC_BC  | WB-H098 | Water Bottle - 30 oz.  |        2 | Other Sales | 2013-07-01   |            | 2026-02-27 11:02:52.364839
   483  | AC_BR  | RA-H123 | Hitch Rack - 4-Bike    |       45 | Other Sales | 2013-07-01   |            | 2026-02-27 11:02:52.364839
   486  | AC_BS  | ST-1401 | All-Purpose Bike Stand |       59 | Mountain    | 2013-07-01   |            | 2026-02-27 11:02:52.364839
```

✅ Category ID extracted  
✅ Product line mapped  
✅ Cost cleaned  
✅ Audit timestamp added

---

### 11.3 silver.crm_sales_details — Sales Transactions

```
 sls_ord_num | sls_prd_key | sls_cust_id | sls_order_dt | sls_ship_dt | sls_due_dt | sls_sales | sls_quantity | sls_price |      dwh_create_date
-------------+-------------+-------------+--------------+-------------+------------+-----------+--------------+-----------+----------------------------
 SO43697     | BK-R93R-62  |       21768 | 2010-12-29   | 2011-01-05  | 2011-01-10 |      3578 |            1 |      3578 | 2026-02-27 11:02:52.371515
 SO43698     | BK-M82S-44  |       28389 | 2010-12-29   | 2011-01-05  | 2011-01-10 |      3400 |            1 |      3400 | 2026-02-27 11:02:52.371515
 SO43699     | BK-M82S-44  |       25863 | 2010-12-29   | 2011-01-05  | 2011-01-10 |      3400 |            1 |      3400 | 2026-02-27 11:02:52.371515
 SO43700     | BK-R50B-62  |       14501 | 2010-12-29   | 2011-01-05  | 2011-01-10 |       699 |            1 |       699 | 2026-02-27 11:02:52.371515
 SO43701     | BK-M82S-44  |       11003 | 2010-12-29   | 2011-01-05  | 2011-01-10 |      3400 |            1 |      3400 | 2026-02-27 11:02:52.371515
```

✅ Invalid dates fixed  
✅ Sales recalculated when needed  
✅ Price derived  
✅ Fact-level grain preserved

---

### 11.4 silver.erp_cust_az12 — Customer Demographics

```
    cid     |   bdate    |  gen   |      dwh_create_date
------------+------------+--------+----------------------------
 AW00011000 | 1971-10-06 | Male   | 2026-02-27 11:02:52.580351
 AW00011001 | 1976-05-10 | Male   | 2026-02-27 11:02:52.580351
 AW00011002 | 1971-02-09 | Male   | 2026-02-27 11:02:52.580351
 AW00011003 | 1973-08-14 | Female | 2026-02-27 11:02:52.580351
 AW00011004 | 1979-08-05 | Female | 2026-02-27 11:02:52.580351
```

✅ NAS prefix removed  
✅ Gender normalized  
✅ Future dates handled

---

### 11.5 silver.erp_loc_a101 — Customer Location

```
    cid     |   cntry   |      dwh_create_date
------------+-----------+----------------------------
 AW00011000 | Australia | 2026-02-27 11:02:52.602458
 AW00011001 | Australia | 2026-02-27 11:02:52.602458
 AW00011002 | Australia | 2026-02-27 11:02:52.602458
 AW00011003 | Australia | 2026-02-27 11:02:52.602458
 AW00011004 | Australia | 2026-02-27 11:02:52.602458
```

✅ Country codes normalized  
✅ Clean join keys

---

### 11.6 silver.erp_px_cat_g1v2 — Product Categories

```
  id   |     cat     |      subcat       | maintenance |      dwh_create_date
-------+-------------+-------------------+-------------+----------------------------
 AC_BR | Accessories | Bike Racks        | Yes         | 2026-02-27 11:02:52.622537
 AC_BS | Accessories | Bike Stands       | No          | 2026-02-27 11:02:52.622537
 AC_BC | Accessories | Bottles and Cages | No          | 2026-02-27 11:02:52.622537
 AC_CL | Accessories | Cleaners          | Yes         | 2026-02-27 11:02:52.622537
 AC_FE | Accessories | Fenders           | No          | 2026-02-27 11:02:52.622537
```

✅ Category hierarchy preserved  
✅ Ready for Gold joins

---

## Final Validation Summary

✅ All Silver tables loaded successfully  
✅ Transformations applied correctly  
✅ Join keys standardized  
✅ Audit columns populated  
✅ Execution time logged  
✅ Output limited to 5 rows per table