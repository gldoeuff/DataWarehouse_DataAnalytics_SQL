/*
======================================
Part to whole Analysis
====================================
Objective:	
  - calculate the contribution of the different categories
	
=====================================
*/


-- product category that contributes to most revenue

WITH sales_per_product_category AS(
	SELECT
	p.category,
	SUM(s.sales_amount) as product_revenue
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key=p.product_key
	GROUP BY p.category
)
SELECT 
category,
product_revenue,
SUM(product_revenue) OVER () as total_revenue,
ROUND(CAST(product_revenue AS FLOAT)/ SUM(product_revenue) OVER () *100,2)  as revenue_pourcentage
FROM sales_per_product_category
ORDER BY revenue_pourcentage DESC;


-- country that contributes to most revenue

WITH sales_per_country AS(
	SELECT
	c.country,
	SUM(s.sales_amount) as product_revenue
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key=c.customer_key
	GROUP BY c.country
)
SELECT 
country,
product_revenue,
SUM(product_revenue) OVER () as total_revenue,
ROUND(CAST(product_revenue AS FLOAT)/ SUM(product_revenue) OVER () *100,2)  as revenue_pourcentage
FROM sales_per_country
ORDER BY revenue_pourcentage DESC;


-- gender that contributes to most revenue

WITH sales_per_gender AS(
	SELECT
	c.gender,
	SUM(s.sales_amount) as product_revenue
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON s.customer_key=c.customer_key
	GROUP BY c.gender
)
SELECT 
gender,
product_revenue,
SUM(product_revenue) OVER () as total_revenue,
ROUND(CAST(product_revenue AS FLOAT)/ SUM(product_revenue) OVER () *100,2)  as revenue_pourcentage
FROM sales_per_gender
ORDER BY revenue_pourcentage DESC;