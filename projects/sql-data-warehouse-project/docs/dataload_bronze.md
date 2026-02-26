# PostgreSQL + VS Code + Bronze Layer Data Load (End-to-End Guide)

This document captures **everything we did**, step by step, so future-you (or anyone else) can repeat the setup **without pain**.

---

## 1. Prerequisites

* macOS
* PostgreSQL 16 installed (official installer)
* pgAdmin installed (optional but useful)
* VS Code installed
* PostgreSQL VS Code extension installed
* Project structure like:

```
sql_dwh_project/
└── sql-data-warehouse-project/
    ├── datasets/
    │   ├── source_crm/
    │   └── source_erp/
    └── scripts/
```

---

## 2. Understanding PostgreSQL Basics (Important)

* **Database**: `dwh`
* **Schemas**: `bronze`, `silver`, `gold`
* **PostgreSQL does NOT support**:

  * `USE database;`
  * `NVARCHAR`
  * `GO`
  * `BULK INSERT`

---

## 3. Connecting PostgreSQL to VS Code

### 3.1 Install VS Code Extension

* Install **PostgreSQL** extension (by Microsoft)

### 3.2 Connection Details (from pgAdmin)

Use these values in VS Code:

| Field       | Value                         |
| ----------- | ----------------------------- |
| Server Name | `localhost`                   |
| Port        | `5432`                        |
| Database    | `dwh`                         |
| Username    | `postgres`                    |
| Password    | your postgres password        |
| SSL         | Prefer (or Disable if needed) |

> PostgreSQL does **not** have a server name like SQL Server — use **host** instead.

---

## 4. PostgreSQL Data Types Conversion (SQL Server → PostgreSQL)

| SQL Server  | PostgreSQL           |
| ----------- | -------------------- |
| NVARCHAR    | VARCHAR / TEXT       |
| DATETIME    | TIMESTAMP            |
| BULK INSERT | COPY / \copy         |
| OBJECT_ID   | DROP TABLE IF EXISTS |

---

## 5. Creating the Bronze Schema

```sql
CREATE SCHEMA IF NOT EXISTS bronze;
```

---

## 6. Creating Bronze Tables (DDL)

Key rules applied:

* `NVARCHAR` → `VARCHAR`
* `DATETIME` → `TIMESTAMP`
* `GO` removed

Tables created:

* `bronze.crm_cust_info`
* `bronze.crm_prd_info`
* `bronze.crm_sales_details`
* `bronze.erp_loc_a101`
* `bronze.erp_cust_az12`
* `bronze.erp_px_cat_g1v2`

(DDL stored in `ddl_bronze.sql`)

---

## 7. Why COPY Failed Inside Stored Procedures

Important PostgreSQL rule:

* `COPY FROM '/path/file.csv'` runs on the **database server**
* Local files in `/Users/...` are **NOT accessible** to postgres
* `\copy` runs on the **client** and uses your OS permissions

### Conclusion

❌ Stored procedures + local CSVs = **not supported**

✅ Use `psql + \copy` for local development

---

## 8. Fixing `psql: command not found`

PostgreSQL was installed via **official macOS installer**, which places binaries here:

```
/Library/PostgreSQL/16/bin/psql
```

### Add psql to PATH

Run in terminal (NOT inside psql):

```bash
echo 'export PATH="/Library/PostgreSQL/16/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Verify:

```bash
psql --version
```

---

## 9. Correct Way to Load CSV Files (Bronze Layer)

### Key Rule

* `\copy` **ONLY works inside psql**
* It will **NOT work** in:

  * VS Code SQL editor
  * pgAdmin query tool

---

## 10. Verified CSV Locations

```
/Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/datasets/source_crm/
    cust_info.csv
    prd_info.csv
    sales_details.csv

/Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/datasets/source_erp/
    CUST_AZ12.csv
    LOC_A101.csv
    PX_CAT_G1V2.csv
```

Paths are **case-sensitive**.

---

## 11. Final Working Bronze Load Script (`dataload_bronze.sql`)

```sql
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
```

---

## 12. Running the Load Script

```bash
psql -h localhost -p 5432 -U postgres -d dwh
```

Inside psql:

```sql
\i /Users/darvikkunalbanda/Data_Engineering/sql_dwh_project/sql-data-warehouse-project/scripts/dataload_bronze.sql
```

Expected output:

```
COPY <row_count>
```

---

## 13. Verifying the Load

```sql
SELECT COUNT(*) FROM bronze.crm_cust_info;
SELECT COUNT(*) FROM bronze.erp_cust_az12;
```

Non-zero counts confirm success ✅

---

## 14. Key Lessons / Takeaways

* PostgreSQL is **strict but predictable**
* File ingestion ≠ SQL Server mindset
* Use:

  * `psql + \copy` for local CSVs
  * Python / Airflow for production
* Always verify:

  * PATH
  * Absolute file paths
  * Case-sensitive filenames

---

✅ **Bronze Layer Setup Completed Successfully**
