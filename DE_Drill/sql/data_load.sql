
SELECT * FROM customers LIMIT 5;

SELECT * FROM read_csv_auto('/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/employees.csv') LIMIT 3;

-- FIX EMPLOYEES
CREATE OR REPLACE TABLE employees AS
SELECT 
    employeeID      AS EmployeeID,
    lastName        AS LastName,
    firstName       AS FirstName,
    title           AS Title,
    titleOfCourtesy AS TitleOfCourtesy,
    birthDate::DATE AS BirthDate,
    hireDate::DATE  AS HireDate,
    address         AS Address,
    city            AS City,
    region          AS Region,
    postalCode      AS PostalCode,
    country         AS Country,
    homePhone       AS HomePhone,
    extension       AS Extension,
    notes           AS Notes,
    reportsTo       AS ReportsTo
FROM read_csv_auto('/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/employees.csv');

-- FIX CATEGORIES
CREATE OR REPLACE TABLE categories AS
SELECT * FROM read_csv_auto('/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/categories.csv');

-- FIX ORDERS
CREATE OR REPLACE TABLE orders AS
SELECT * FROM read_csv_auto('/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/orders.csv');

-- FIX SUPPLIERS
CREATE OR REPLACE TABLE suppliers AS
SELECT * FROM read_csv_auto('/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/suppliers.csv');

-- VERIFY
SELECT 'categories' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL SELECT 'employees',  COUNT(*) FROM employees
UNION ALL SELECT 'orders',     COUNT(*) FROM orders
UNION ALL SELECT 'suppliers',  COUNT(*) FROM suppliers;