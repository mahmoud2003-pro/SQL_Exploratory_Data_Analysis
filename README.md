# 📊 Exploratory Data Analysis (EDA) & Advanced Data Analytics

## 📌 Overview

This project demonstrates a complete Exploratory Data Analysis (EDA) and Advanced Business Analytics workflow using SQL Server on a dimensional data warehouse (Gold Layer).

The goal of this project is to transform raw transactional data into meaningful business insights by building analytical queries, KPIs, ranking analysis, segmentation models, and reusable reporting views.

This simulates a real-world Business Intelligence reporting environment.

---

## 🏗️ Data Architecture

The analysis is performed on a Star Schema model:

- `gold.fact_sales` → Sales transactions (Fact Table)
- `gold.dim_customers` → Customer Dimension
- `gold.dim_products` → Product Dimension

This structure reflects production-level data warehouse design.

---

## 🔍 Exploratory Data Analysis (EDA)

The project includes:

- Database metadata exploration
- Data profiling and validation
- Country and category distribution analysis
- Customer demographic analysis
- Sales time-range exploration
- Business metrics aggregation

---

## 📈 Business Metrics & KPIs

Key performance indicators generated:

- Total Sales
- Total Quantity Sold
- Average Price
- Total Orders
- Total Customers
- Revenue Contribution Percentage
- Running Total Sales
- Moving Average Price
- Yearly & Monthly Sales Trends

---

## 🏆 Ranking & Performance Analysis

- Top 10 revenue-generating products
- Lowest-performing products
- Top customers by revenue
- Customers with the fewest orders
- Category contribution to total sales

Advanced SQL window functions used:

- `ROW_NUMBER()`
- `LAG()`
- `AVG() OVER()`
- `SUM() OVER()`

---

## 👥 Customer Analytics Report

### View: `gold.report_customers`

A reusable analytical customer report including:

- Age segmentation
- Customer segmentation (VIP / Regular / New)
- Total orders
- Total revenue
- Total quantity purchased
- Customer lifespan (months)
- Recency analysis
- Average order value
- Average monthly spending

This simulates a CRM analytical reporting system.

---

## 📦 Product Analytics Report

### View: `gold.report_products`

A reusable product performance report including:

- Product performance segmentation (Low / Mid / High)
- Total sales revenue
- Total orders
- Total quantity sold
- Unique customer count
- Product lifespan
- Recency tracking
- Average selling price
- Average monthly revenue

This simulates commercial product performance monitoring.

---

## 🧠 Advanced SQL Concepts Applied

- Common Table Expressions (CTEs)
- Window Functions
- Ranking Functions
- Aggregations & Grouping
- CASE-based Segmentation
- Percent Contribution Calculations
- Time-Based Analysis
- Analytical View Creation
- Star Schema Reporting Logic

---

## 🎯 Business Value

This project demonstrates the ability to:

- Translate business requirements into SQL logic
- Design KPI-driven reporting systems
- Build reusable analytical views
- Perform customer and product segmentation
- Apply advanced SQL for Business Intelligence
- Work with dimensional data models

---

## 🛠️ Technologies Used

- SQL Server
- T-SQL
- Data Warehouse (Star Schema)
- Analytical Views
- Window Functions
- Common Table Expression (CTE)

---

## 🚀 Project Outcome

This project showcases strong analytical thinking, data modeling understanding, and advanced SQL skills required for:

- Data Analyst
- BI Developer
- Analytics Engineer

It reflects real-world business reporting and performance analysis scenarios.
