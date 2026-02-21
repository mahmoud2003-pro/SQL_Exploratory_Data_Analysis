/*
=================================================================================
Product Report
=================================================================================
Purpose:
	- This report consolidates key product metrics and behaviors.

Highlights:
	1. Gathers essential feild such as product names, category, subcategory ,and cost.
	2. Segments products by revenue to identify High-Performance, Mid-Range, or Low-Performance.
	3. Aggregates product-level matrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order revenue
		- average monthly revenue
=================================================================================
*/

IF OBJECT_ID('gold.report_products', 'v') IS NOT NULL
	DROP VIEW gold.report_products;

GO

CREATE VIEW gold.report_products AS
WITH base_query AS		-- 1) Retrieves core columns from tables
(
	SELECT
		S.order_number,
		S.customer_key,
		S.order_date,
		S.sales_amount,
		S.quantity,
		P.product_key,
		P.product_name,
		P.category,
		P.subcategory,
		P.cost
	FROM gold.fact_sales S
	LEFT JOIN gold.dim_products P ON P.product_key = S.product_key
	WHERE order_date IS NOT NULL
)
, product_aggregation AS		-- 2) Summarizes key matrics at the product level
(
	SELECT
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT customer_key) AS total_customers,
		MAX(order_date) AS last_order_date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
		ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)), 2) AS avg_selling_price
	FROM base_query
	GROUP BY product_key,product_name,category,subcategory,cost
)
SELECT
product_key,
product_name,
category,
subcategory,
cost,
total_sales,
CASE WHEN total_sales < 10000 THEN 'Low-Performance'
	 WHEN total_sales >= 10000 AND total_sales < 100000 THEN 'Mid-Range'
	 ELSE 'High-Performance'
END AS product_segment,
total_orders,
total_quantity,
total_customers,
last_order_date,
DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency,
lifespan,
avg_selling_price,
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales / total_orders
END AS avg_order_revenue,		-- compute average order revenue
CASE WHEN lifespan = 0 THEN total_sales
	 ELSE total_sales / lifespan
END AS avg_monthly_revenue		-- compute average monthly revenue
FROM product_aggregation
