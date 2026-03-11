-- ============================================================
-- NORTHWIND DATABASE SETUP FOR DUCKDB
-- ============================================================

-- 1. CATEGORIES
CREATE OR REPLACE TABLE categories (
    CategoryID      INTEGER PRIMARY KEY,
    CategoryName    VARCHAR(15),
    Description     TEXT
);
COPY categories FROM '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/categories.csv' (HEADER TRUE, DELIMITER ',');

-- 2. SUPPLIERS
CREATE OR REPLACE TABLE suppliers (
    SupplierID      INTEGER PRIMARY KEY,
    CompanyName     VARCHAR(40),
    ContactName     VARCHAR(30),
    ContactTitle    VARCHAR(30),
    Address         VARCHAR(60),
    City            VARCHAR(15),
    Region          VARCHAR(15),
    PostalCode      VARCHAR(10),
    Country         VARCHAR(15),
    Phone           VARCHAR(24),
    Fax             VARCHAR(24)
);
COPY suppliers FROM '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/suppliers.csv' (HEADER TRUE, DELIMITER ',');

-- 3. CUSTOMERS
CREATE OR REPLACE TABLE customers (
    CustomerID      CHAR(5) PRIMARY KEY,
    CompanyName     VARCHAR(40),
    ContactName     VARCHAR(30),
    ContactTitle    VARCHAR(30),
    Address         VARCHAR(60),
    City            VARCHAR(15),
    Region          VARCHAR(15),
    PostalCode      VARCHAR(10),
    Country         VARCHAR(15),
    Phone           VARCHAR(24),
    Fax             VARCHAR(24)
);
COPY customers FROM '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/customers.csv' (HEADER TRUE, DELIMITER ',');

-- 4. EMPLOYEES
CREATE OR REPLACE TABLE employees (
    EmployeeID      INTEGER PRIMARY KEY,
    LastName        VARCHAR(20),
    FirstName       VARCHAR(10),
    Title           VARCHAR(30),
    TitleOfCourtesy VARCHAR(25),
    BirthDate       DATE,
    HireDate        DATE,
    Address         VARCHAR(60),
    City            VARCHAR(15),
    Region          VARCHAR(15),
    PostalCode      VARCHAR(10),
    Country         VARCHAR(15),
    HomePhone       VARCHAR(24),
    Extension       VARCHAR(4),
    Notes           TEXT,
    ReportsTo       INTEGER
);
COPY employees FROM '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/employees.csv' (HEADER TRUE, DELIMITER ',');

-- 5. SHIPPERS
CREATE OR REPLACE TABLE shippers (
    ShipperID       INTEGER PRIMARY KEY,
    CompanyName     VARCHAR(40),
    Phone           VARCHAR(24)
);
COPY shippers FROM '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/shippers.csv' (HEADER TRUE, DELIMITER ',');

-- 6. PRODUCTS
CREATE OR REPLACE TABLE products (
    ProductID       INTEGER PRIMARY KEY,
    ProductName     VARCHAR(40),
    SupplierID      INTEGER,
    CategoryID      INTEGER,
    QuantityPerUnit VARCHAR(20),
    UnitPrice       DECIMAL(10,2),
    UnitsInStock    SMALLINT,
    UnitsOnOrder    SMALLINT,
    ReorderLevel    SMALLINT,
    Discontinued    INTEGER
);
COPY products FROM '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/products.csv' (HEADER TRUE, DELIMITER ',');

-- 7. ORDERS
CREATE OR REPLACE TABLE orders (
    OrderID         INTEGER PRIMARY KEY,
    CustomerID      CHAR(5),
    EmployeeID      INTEGER,
    OrderDate       DATE,
    RequiredDate    DATE,
    ShippedDate     DATE,
    ShipVia         INTEGER,
    Freight         DECIMAL(10,2),
    ShipName        VARCHAR(40),
    ShipAddress     VARCHAR(60),
    ShipCity        VARCHAR(15),
    ShipRegion      VARCHAR(15),
    ShipPostalCode  VARCHAR(10),
    ShipCountry     VARCHAR(15)
);
COPY orders FROM '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/orders.csv' (HEADER TRUE, DELIMITER ',');

-- 8. ORDER_DETAILS
CREATE OR REPLACE TABLE order_details (
    OrderID         INTEGER,
    ProductID       INTEGER,
    UnitPrice       DECIMAL(10,2),
    Quantity        SMALLINT,
    Discount        FLOAT,
    PRIMARY KEY (OrderID, ProductID)
);
COPY order_details FROM '/Users/darvikkunalbanda/DataEngineering/DE_Drill/dataset/northwind_data/order_details.csv' (HEADER TRUE, DELIMITER ',');

-- ============================================================
-- VERIFY — Row counts for all tables
-- ============================================================
SELECT 'categories'     AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL
SELECT 'suppliers',     COUNT(*) FROM suppliers
UNION ALL
SELECT 'customers',     COUNT(*) FROM customers
UNION ALL
SELECT 'employees',     COUNT(*) FROM employees
UNION ALL
SELECT 'shippers',      COUNT(*) FROM shippers
UNION ALL
SELECT 'products',      COUNT(*) FROM products
UNION ALL
SELECT 'orders',        COUNT(*) FROM orders
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
ORDER BY table_name;
