/*
=================================================================================
Customer Report
=================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors.

Highlights:
	1. Gathers essential feild such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level matrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
=================================================================================
*/
IF OBJECT_ID('gold.report_customers', 'v') IS NOT NULL
  DROP VIEW gold.report_customers;

GO
  
CREATE VIEW gold.report_customers AS
WITH base_query AS		-- 1) Retrieves core columns from tables
(
	SELECT
		S.order_number,
		S.product_key,
		S.order_date,
		S.sales_amount,
		S.quantity,
		C.customer_key,
		C.customer_number,
		CONCAT(C.first_name, ' ', C.last_name) AS customer_name,
		DATEDIFF(YEAR, C.birth_date, GETDATE()) AS age
	FROM gold.fact_sales S
	LEFT JOIN gold.dim_customers C ON S.customer_key = C.customer_key
	WHERE S.order_date IS NOT NULL
)
, customer_aggregation AS		-- 2) Summarizes key matrics at the customer level
(
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		COUNT(DISTINCT order_number) AS total_order,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY customer_key,customer_number,customer_name,age
)
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 THEN 'Under 20'
		 WHEN age BETWEEN 20 AND 30 THEN '20-30'
		 WHEN age BETWEEN 31 AND 40 THEN '30-40'
		 WHEN age BETWEEN 41 AND 50 THEN '40-50'
		 ELSE 'Above 50'
	END AS age_group,
	CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		 ELSE 'New'
	END AS customer_segment,
	total_order,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
	lifespan,
	CASE WHEN total_sales = 0 THEN 0
		 ELSE total_sales / total_order
	END AS avg_order_value,			-- compute average order value
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales / lifespan
	END AS avg_monthly_spend		-- compute average monthly spend
FROM customer_aggregation
