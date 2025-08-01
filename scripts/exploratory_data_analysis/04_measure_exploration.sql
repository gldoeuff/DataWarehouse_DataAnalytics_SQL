/*
===============================
Measure Exploration
================================
objective:
	- calculate total, average ... for quick overview
	- look at the overall trend

*/


-- total number of customer---
SELECT COUNT(customer_key) as total_customers
FROM gold.dim_customers

-- total customer that have orders
SELECT COUNT(DISTINCT customer_key) as customers_with_order
FROM gold.fact_sales

--total number of product
SELECT COUNT(product_key) as total_products FROM gold.dim_products

--total number of products per category
SELECT
category,
COUNT(product_key)
FROM gold.dim_products
GROUP BY category

-- total of products sold--
SELECT SUM(quantity) as products_sold
FROM gold.fact_sales

-- total of product sold per category
SELECT dp.category, SUM(fs.quantity) as products_sold
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key=dp.product_key
GROUP BY dp.category

--total of sales
SELECT SUM(sales_amount) as total_sales
FROM gold.fact_sales


--total sales per category 
SELECT dp.category, SUM(fs.sales_amount) as products_sold
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key=dp.product_key
GROUP BY dp.category

--total sales per year

SELECT
YEAR (order_date) as sales_year,
SUM(sales_amount) as total_sales
FROM gold.fact_sales
GROUP BY YEAR (order_date)
ORDER BY YEAR(order_date)

-- Report that shows all key metrics
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(customer_key) FROM gold.dim_customers;