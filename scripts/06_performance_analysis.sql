/*  Analyze the yearly performance of products by comparing their sales
	to both the average sales performance of the product and the previous year's sales */

WITH CTE_yearly AS
(
	SELECT
	YEAR(S.order_date) AS order_year,
	P.product_name,
	SUM(S.sales_amount) AS current_sales
	FROM gold.fact_sales S
	LEFT JOIN gold.dim_products P ON P.product_key = S.product_key
	WHERE S.order_date IS NOT NULL
	GROUP BY YEAR(S.order_date), P.product_name
)

SELECT
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_average,
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'High'
	 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Low'
	 ELSE 'Average'
END AS performance_status_avg,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS prev_year,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_prev_year,
CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END AS change_by_year
FROM CTE_yearly
ORDER BY product_name ASC, order_year ASC
