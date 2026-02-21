-- Explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES;


-- Explore all columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


-- Explore all countries our customers come from
SELECT DISTINCT country FROM gold.dim_customers;


-- Explore all categories "The major division"
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1,2,3;


-- Explore date
SELECT 
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;


-- Find the youngest and oldest customer
SELECT
MIN(birth_date) AS oldest_customer,
DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS oldest_age,
MAX(birth_date) AS youngest_customer,
DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS youngest_age
FROM gold.dim_customers;


-- Measures Exploration
-- Generate a report that shows all key matrics of the business
SELECT 'Total sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total number orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total number products' AS measure_name, COUNT(DISTINCT product_name) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total number customers' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.dim_customers



-- Find the total customers by countries
SELECT
country,
COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC


-- Find the total customers by gender
SELECT
gender,
COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC


-- Find the total products by category
SELECT
category,
COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC
