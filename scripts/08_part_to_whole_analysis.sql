-- Which categories contribute the most to overall sales?
WITH category_sales AS
(
	SELECT
	P.category,
	SUM(S.sales_amount) AS total_sales
	FROM gold.fact_sales S
	LEFT JOIN gold.dim_products P ON S.product_key = P.product_key
	GROUP BY P.category
)
SELECT
category,
total_sales,
SUM(total_sales) OVER() AS overall_sales,
CONCAT(CAST(total_sales*1.0 / SUM(total_sales) OVER() *100 AS DECIMAL(10,2)) , '%') AS sales_percent_of_total
FROM category_sales
ORDER BY total_sales DESC
