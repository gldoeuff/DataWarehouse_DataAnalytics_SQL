/*
===============================
Date Range Exploration
================================
Objective:
	- understand the range of historical data
*/

----------------------------
-- costumer table
----------------------------
SELECT 
MIN(birthdate) as oldest_date,
DATEDIFF( YEAR, MIN(birthdate), GETDATE()) as oldest_age,
MAX(birthdate) as youngest_date,
DATEDIFF( YEAR, MAX(birthdate), GETDATE()) as youngest_age,
DATEDIFF( YEAR, MIN(birthdate),MAX(birthdate)) as diff_age
FROM gold.dim_customers


SELECT DISTINCT 
MIN(create_date) as first_date,
MAX(create_date) as last_date
FROM gold.dim_customers


-----------------------
--product table
-----------------------

SELECT DISTINCT start_date FROM gold.dim_products

-- life span for the product start date
SELECT DATEDIFF(YEAR, MIN(start_date), MAX(start_date)) FROM gold.dim_products

-- list of the oldest products 
SELECT  product_name, start_date
FROM gold.dim_products
WHERE start_date IN ( SELECT MIN(start_date) FROM gold.dim_products)

--list of the newest products
SELECT  product_name, start_date
FROM gold.dim_products
WHERE start_date IN ( SELECT MAX(start_date) FROM gold.dim_products)


--------------------------------
-- sales table
--------------------------------

SELECT * FROM gold.fact_sales

SELECT 
MIN(order_date) as first_order,
MAX (order_date) as last_order
FROM gold.fact_sales

-- list of the first orders

SELECT 
dc.first_name,
dc.last_name,
dp.product_name,
fs.order_date
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key=dc.customer_key
LEFT JOIN gold.dim_products dp
ON fs.product_key=dp.product_key
WHERE fs.order_date IN (SELECT MIN(order_date) FROM gold.fact_sales)

--list of the last orders

SELECT 
dc.first_name,
dc.last_name,
dp.product_name,
fs.order_date
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key=dc.customer_key
LEFT JOIN gold.dim_products dp
ON fs.product_key=dp.product_key
WHERE fs.order_date IN (SELECT MAX(order_date) FROM gold.fact_sales)