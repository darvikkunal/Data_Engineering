# Exploratory Data Analysis (EDA) & Reporting Documentation

This document provides an overview of the analytical SQL scripts developed for the EDA project. These scripts cover a wide range of data exploration, performance analysis, and business reporting within the `gold` schema.

## Table of Contents
1. [Basic Exploration and Metrics](#1-basic-exploration-and-metrics)
2. [Advanced Time-Series Analysis](#2-advanced-time-series-analysis)
3. [Segmentation and Comparative Analysis](#3-segmentation-and-comparative-analysis)
4. [Comprehensive Business Reports](#4-comprehensive-business-reports)

---

## 1. Basic Exploration and Metrics
**File:** `analysis.sql`

This script serves as the foundational exploration layer, identifying the structure of the database and key high-level metrics.

### Key Components:
- **Database Exploration:** Investigates the `INFORMATION_SCHEMA` to list tables and columns, particularly focusing on `dim_customers`.
- **Dimension Exploration:** 
    - Analyzes customer demographics (countries of origin).
    - Reviews product hierarchy (categories and subcategories).
- **Date Exploration:**
    - Identifies the operational range of the data (first vs. last order dates).
    - Analyzes customer age distribution (youngest, oldest, and average age).
- **Measures Exploration:** Calculates primary business KPIs:
    - Total Sales, Total Items Sold, Average Selling Price.
    - Total Unique Orders, Products, and Customers.
- **Magnitude Analysis:** 
    - Breaks down revenue and customer counts by country and gender.
    - Analyzes product category performance (revenue and average cost).
    - **Ranking:** Identifies top 5 and bottom 5 performing products and top 10 high-value customers.

---

## 2. Advanced Time-Series Analysis
**File:** `advance_analysis.sql`

Focuses on how business metrics evolve over time and compares performance against historical benchmarks.

### Key Components:
- **Change Over Time:** 
    - Aggregates sales, customer count, and quantity by year and month.
    - Demonstrates multiple SQL techniques (`EXTRACT`, `DATE_TRUNC`, `TO_CHAR`) for time-based grouping.
- **Cumulative Analysis:** 
    - Calculates running totals of sales over time.
    - Computes moving averages for prices to smooth out fluctuations.
- **Year-over-Year (YoY) Performance:**
    - Compares current product sales to the average sales for that specific product.
    - Utilizes `LAG` functions to compare current year performance against the previous year (PY), identifying increases or decreases in revenue.

---

## 3. Segmentation and Comparative Analysis
**File:** `advance_analysis_2.sql` (Part 1)

This script moves into deeper data segmentation to identify patterns and specific cohorts.

### Key Components:
- **Part-to-Whole Analysis:** 
    - Determines the percentage contribution of each product category to the overall total sales.
- **Data Segmentation:**
    - **Product Cost Segmentation:** Groups products into price brackets (e.g., 'Below 100', '100-500', etc.).
    - **Customer Lifecycle Segmentation:** Categorizes customers into three tiers based on spending and lifespan:
        - **VIP:** > 12 months history AND > €5,000 spend.
        - **Regular:** > 12 months history AND ≤ €5,000 spend.
        - **New:** < 12 months history.

---

## 4. Comprehensive Business Reports
**File:** `advance_analysis_2.sql` (Part 2)

The final section consolidates all previous logic into reusable views and reporting structures for business stakeholders.

### Customer Report (`gold.report_customers`)
A holistic view of customer behavior including:
- **Demographics:** Age groups and location.
- **Segmentation:** VIP/Regular/New status.
- **KPIs:** 
    - **Recency:** Months since the last order.
    - **Lifespan:** Months between first and last order.
    - **AVO (Average Order Value):** Total revenue divided by total orders.
    - **Monthly Spend:** Average revenue generated per month of lifespan.

### Product Report
A focused analysis of product performance metrics:
- **Aggregations:** Total orders, customers, sales, and quantity per product.
- **Product Health:** Sales recency and product lifespan in the catalog.
- **Pricing Metrics:** Average selling price and cost analysis.

---
*Note: These scripts are designed to run against the `gold` schema of the data warehouse.*
