-- Ranking Analysis
-- Which 10 products generate the highest revenue
SELECT TOP 10
P.product_name,
SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales S
LEFT JOIN gold.dim_products P ON P.product_key = S.product_key
GROUP BY P.product_name
ORDER BY total_revenue DESC


-- What are the 10 worst-performing products in terms of sales
SELECT *
FROM (
SELECT
ROW_NUMBER() OVER(ORDER BY SUM(S.sales_amount) ASC) AS rank_products,
P.product_name,
SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales S
LEFT JOIN gold.dim_products P ON P.product_key = S.product_key
GROUP BY P.product_name
) T
WHERE rank_products <= 10


-- Find the top 10 customers who have generated the highest revenue
SELECT *
FROM (
SELECT
ROW_NUMBER() OVER(ORDER BY SUM(S.sales_amount) DESC) AS rank_customers,
C.customer_key,
C.first_name,
C.last_name,
SUM(S.sales_amount) AS total_revenue
FROM gold.fact_sales S
LEFT JOIN gold.dim_customers C ON C.customer_key = S.customer_key
GROUP BY C.customer_key,C.first_name,C.last_name
) T
WHERE rank_customers <= 10


-- The 5 customers with the fewest orders placed
SELECT TOP 5
C.customer_key,
C.first_name,
C.last_name,
COUNT(DISTINCT S.order_number) AS total_orders
FROM gold.fact_sales S
LEFT JOIN gold.dim_customers C ON C.customer_key = S.customer_key
GROUP BY C.customer_key,C.first_name,C.last_name
ORDER BY total_orders ASC
