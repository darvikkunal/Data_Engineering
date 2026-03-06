# Gold Layer Data Integration: Creating a Business-Ready Data Warehouse

![Data Flow Diagram](/projects/sql-data-warehouse-project/docs/dataflow.png)

This document explains the final step in our data warehousing process: creating the "gold" layer. This layer takes the cleaned and standardized data from the "silver" layer and transforms it into a format that's optimized for business intelligence and analytics. Think of it as taking raw ingredients (silver data) and creating a finished meal (gold data) that's ready to be served to our business users.

The gold layer is designed around a "star schema," which is a common and efficient way to model data for reporting. A star schema consists of two types of tables:

*   **Dimension Tables:** These tables describe the "who, what, where, when" of our business. They contain descriptive information about our customers, products, locations, and so on.
*   **Fact Tables:** These tables contain the "how much" and "how many." They store the key business metrics and measurements, like sales amount, quantity, and price.

This structure makes it easy for business users to "slice and dice" the data to answer important questions.

![Sales Data Mart Star Schema](/projects/sql-data-warehouse-project/docs/starschema.png)

Here's a breakdown of how we build our gold layer:

## 1. Creating the Customer Dimension (`gold.dim_customers`)

**Goal:** To create a single, unified view of our customers.

We start by creating a comprehensive customer dimension table. This table combines customer information from two different source systems: our CRM (Customer Relationship Management) system and our ERP (Enterprise Resource Planning) system.

**What we do:**

*   **Combine Data:** We join the `crm_cust_info` table from our CRM with the `erp_cust_az12` and `erp_loc_a101` tables from our ERP. This brings together a customer's basic information with their location and other details.
*   **Handle Data Inconsistencies:** We've noticed that gender information can be inconsistent between the two systems. We've decided to use the CRM as the primary source of truth for gender. If the CRM has a value other than "other," we use that. Otherwise, we take the value from the ERP. If neither system has the information, we mark it as "n/a".
*   **Create a Unique Key:** We generate a new, unique key (`customer_key`) for each customer. This is called a "surrogate key," and it helps to ensure that we can always uniquely identify a customer, even if their customer ID changes in one of the source systems.

**Result:** A clean, consolidated `dim_customers` table that gives us a 360-degree view of our customers.

## 2. Creating the Product Dimension (`gold.dim_products`)

**Goal:** To create a master list of our current products.

Next, we create a product dimension table. This table will serve as the single source of truth for all product-related information.

**What we do:**

*   **Combine Product and Category Information:** We join the `crm_prd_info` table (which contains product details) with the `erp_px_cat_g1v2` table (which contains product category and subcategory information).
*   **Focus on Current Products:** We only want to include active products in our dimension. We filter out any products that have an end date, so we're left with a clean list of what we're currently selling.
*   **Create a Unique Key:** Just like with customers, we create a unique `product_key` for each product.

**Result:** A `dim_products` table that provides a complete and up-to-date catalog of our products.

## 3. Creating the Sales Fact Table (`gold.fact_sales`)

**Goal:** To bring together our sales data with our new customer and product dimensions.

Finally, we create our fact table. This is where we store our sales transactions. The real power of the fact table is that it connects our sales data to our customer and product dimensions using the surrogate keys we created.

**What we do:**

*   **Connect to Dimensions:** We take our `crm_sales_details` table from the silver layer and join it with our new `gold.dim_customers` and `gold.dim_products` tables. We use the `customer_key` and `product_key` to link the sales transactions to the specific customer who made the purchase and the specific product that was sold.

**Result:** A `fact_sales` table that allows us to analyze our sales data in powerful ways. For example, we can now easily answer questions like:

*   "What are the total sales for each product category?"
*   "Who are our top 100 customers by sales amount?"
*   "What is the average order size for customers in a particular country?"

### Foreign Key Integrity Check

To ensure the quality and reliability of our data, we perform a final check to make sure that every sale in our `fact_sales` table is linked to a valid customer and a valid product in our dimension tables. This helps to prevent orphaned records and ensures that our reports are accurate.



---

## Gold Layer Data Catalog

### `gold.dim_customers`

| Column Name      | Data Type | Description                               |
| ---------------- | --------- | ----------------------------------------- |
| customer_key     | BIGINT    | Surrogate key for the customer dimension. |
| customer_id      | INT       | Customer ID from the CRM system.          |
| customer_number  | VARCHAR(50)| Customer key from the CRM system.         |
| first_name       | VARCHAR(50)| Customer's first name.                    |
| last_name        | VARCHAR(50)| Customer's last name.                     |
| country          | VARCHAR(50)| Customer's country from the ERP system.   |
| martial_status   | VARCHAR(50)| Customer's marital status.                |
| gender           | VARCHAR(50)| Customer's gender, consolidated from CRM and ERP. |
| birthdate        | DATE      | Customer's birthdate from the ERP system. |
| create_date      | DATE      | Date the customer was created in the CRM system. |

### `gold.dim_products`

| Column Name    | Data Type  | Description                                |
| -------------- | ---------- | ------------------------------------------ |
| product_key    | BIGINT     | Surrogate key for the product dimension.   |
| product_id     | INT        | Product ID from the CRM system.            |
| product_number | VARCHAR(50)| Product key from the CRM system.           |
| product_name   | VARCHAR(50)| Product's name.                            |
| category_id    | VARCHAR(50)| Category ID from the CRM system.           |
| category       | VARCHAR(50)| Product's category from the ERP system.    |
| subcategory    | VARCHAR(50)| Product's subcategory from the ERP system. |
| maintenance    | VARCHAR(50)| Maintenance information from the ERP system. |
| cost           | INT        | Product's cost.                            |
| product_line   | VARCHAR(50)| Product's line.                            |
| start_date     | DATE       | Date the product became available.         |

### `gold.fact_sales`

| Column Name     | Data Type  | Description                                      |
| --------------- | ---------- | ------------------------------------------------ |
| order_number    | VARCHAR(50)| Sales order number from the CRM system.          |
| product_key     | BIGINT     | Foreign key to the `gold.dim_products` table.    |
| customer_key    | BIGINT     | Foreign key to the `gold.dim_customers` table.   |
| order_date      | DATE       | Date the order was placed.                       |
| shipping_date   | DATE       | Date the order was shipped.                      |
| due_date        | DATE       | Date the order is due.                           |
| sales_amount    | INT        | Total sales amount for the order.                |
| quantity        | INT        | Quantity of products in the order.               |
| price           | INT        | Price of the product in the order.               |