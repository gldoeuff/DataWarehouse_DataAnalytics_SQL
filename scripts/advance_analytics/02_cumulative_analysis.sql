/*
========================================
Cummulative Analysis
=======================================
Objective:
	- Track the cumulative performance 
	
=========================================
*/

-- calculate the total sales per month and the running total sales


SELECT
order_year,
total_revenue,
SUM(total_revenue) OVER (ORDER BY order_year) AS running_total_revenue
FROM(
	SELECT 
	YEAR(order_date) as order_year,
	SUM(sales_amount) as total_revenue
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date)
)t
ORDER BY order_year