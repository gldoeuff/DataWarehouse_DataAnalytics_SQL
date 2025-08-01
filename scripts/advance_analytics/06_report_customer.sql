/*
===========================================
Customer Report
==========================================
Objective:
	- report that join all the metric and behaviour of the customer

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - months active
		- average order value
		- average monthly spend
==========================================
*/



--1. Base Query: core columns from tables

WITH base_query AS(
	SELECT
		s.order_number,
		s.product_key,
		s.order_date,
		s.sales_amount,
		s.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		DATEDIFF(year, c.birthdate, GETDATE()) age
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = s.customer_key
	WHERE order_date IS NOT NULL
),
-- Aggregation Query: Summarize all the customer info
aggregation_query AS(
SELECT
customer_key,
customer_number,
customer_name,
age,
COUNT(order_number) as total_orders,
SUM( sales_amount) as total_spent,
SUM( quantity) as total_products,
COUNT( DISTINCT product_key) as distinct_products,
SUM( sales_amount)/SUM( quantity) as average_price_per_product,
MIN(order_date) as first_order_date,
MAX(order_date) as last_order_date,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as active_lifespan_months
FROM base_query
GROUP BY customer_key,
customer_number,
customer_name,
age

)
SELECT 
customer_key,
customer_number,
customer_name, 
age,
CASE 
	WHEN age < 20 THEN '<20'
	WHEN age >=20 AND age < 30 THEN '20-30'
	WHEN age >=30 AND age <50 THEN '30-50'
	WHEN age >=50 THEN '>50'
END as age_category,
CASE
	WHEN active_lifespan_months >=12 AND total_spent >=6000 THEN 'VIP'
	WHEN active_lifespan_months >=12 AND total_spent <6000 THEN 'Regular'
	ELSE 'New'
END as customer_category,
total_orders,
total_spent,
total_products,
distinct_products,
average_price_per_product, 
first_order_date,
last_order_date,
CASE 
	WHEN  active_lifespan_months=0 THEN total_spent
	ELSE total_spent/active_lifespan_months
END as average_monthly_spent,
active_lifespan_months
FROM aggregation_query

