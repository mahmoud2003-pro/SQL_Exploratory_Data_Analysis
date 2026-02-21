-- Segment the products into cost ranges and count how many product fall into each segmant
WITH product_segments AS
(
	SELECT
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Under 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
		 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
		 WHEN cost > 1000 THEN 'Above 1000'
	END AS cost_range
	FROM gold.dim_products
)
SELECT
cost_range,
COUNT(product_key) AS number_products
FROM product_segments
GROUP BY cost_range
ORDER BY number_products DESC
--------------------------------------------------------------------------------

/*
Group customers into three segments based on their spending behavior:
- VIP: customers with at least 12 months of history and spending more than 5000.
- Regular: customers with at least 12 months of history and spending 5000 or less.
- New: customers with a lifespan less than 12 months.
And find the total number of customers by each group.
*/
WITH CTE AS
(
	SELECT
	C.customer_key,
	SUM(S.sales_amount) AS total_spending,
	MIN(S.order_date) AS first_order,
	MAX(S.order_date) AS last_order,
	DATEDIFF(MONTH,MIN(S.order_date),MAX(S.order_date)) AS lifespan
	FROM gold.fact_sales S
	LEFT JOIN gold.dim_customers C ON S.customer_key = C.customer_key
	GROUP BY C.customer_key
)
,customer_segmants AS
(
	SELECT
	customer_key,
	total_spending,
	lifespan,
	CASE WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
		 WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
		 ELSE 'New'
	END AS customer_types
	FROM CTE
)
SELECT
customer_types,
COUNT(customer_key) AS total_customers
FROM customer_segmants
GROUP BY customer_types
ORDER BY total_customers DESC
