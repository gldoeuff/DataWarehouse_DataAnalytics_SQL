/*
=====================================
Change over time Analysis
====================================
Objective:
	- track trends and changes over time
	- measure growth or decline over a specific time period
	- identify seasonality

=======================================
*/

-- sales performance over time

-- over the years

SELECT
YEAR(order_date) as order_year,
SUM(sales_amount) year_revenue,
COUNT(DISTINCT customer_key) as total_customers,
COUNT(order_number) as total_orders,
SUM(quantity) as total_products
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year


-- over the months

SELECT
YEAR(order_date) as order_year,
DATENAME(MONTH,order_date) as order_month,
SUM(sales_amount) year_revenue,
COUNT(DISTINCT customer_key) as total_customers,
COUNT(order_number) as total_orders,
SUM(quantity) as total_products
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),DATENAME(MONTH,order_date)
ORDER BY order_year, order_month


