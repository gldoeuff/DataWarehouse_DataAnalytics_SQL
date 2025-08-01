/*
=================================
Products Report
=================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - lifespan
       - average monthly revenue
=================================
*/


---Create Product Report


IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

	WITH base_query AS(
		SELECT
		s.order_number,
		s.customer_key,
		s.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.product_line,
		s.sales_amount,
		s.price,
		s.quantity,
		s.order_date
		FROM gold.fact_sales s
		LEFT JOIN gold.dim_products p
		ON s.product_key=p.product_key
	)
	, aggregation_query AS(
	SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	product_line,
	SUM(sales_amount) as total_revenue,
	SUM(quantity) as total_quantity_sold,
	AVG(price) as average_price,
	COUNT( DISTINCT customer_key) nb_customer,
	MIN(order_date) first_order_date,
	MAX(order_date) last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) lifespan_months

	FROM base_query
	GROUP BY product_key,
	product_name,
	category,
	subcategory,
	product_line
	)
	SELECT 
	product_key, 
	product_name,
	category,
	subcategory,
	product_line,
	total_revenue,
	CASE 
		WHEN total_revenue > 50000 THEN 'High-Performer'
		WHEN total_revenue <= 50000 AND total_revenue > 10000 THEN 'Mid-Performer'
		ELSE 'Low-Performer'
	END product_performance,
	total_quantity_sold, 
	average_price,
	nb_customer, 
	first_order_date,
	last_order_date,
	CASE 
		WHEN lifespan_months =0 THEN  total_revenue
		ELSE total_revenue/lifespan_months
	END as average_monthly_revenue,
	lifespan_months
	FROM aggregation_query

