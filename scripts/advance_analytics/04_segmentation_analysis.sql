/*
=======================================
Segmentation Analysis
=======================================
Objective:
	- organize the date in different categorie for meaningfull inside

=======================================
*/

-- organise products by cost categories


WITH product_cost_category AS(
	SELECT 
	product_key,
	product_name,
	cost,
	CASE 
		WHEN cost < 100 THEN '<100'
		WHEN cost >= 100 AND cost <500 THEN '100-500'
		WHEN cost >= 500 AND cost <1000 THEN '500-1000'
		ELSE '>1000'
	END as cost_category
	FROM gold.dim_products
)

SELECT 
cost_category,
COUNT(product_key) as nb_product
FROM product_cost_category
GROUP BY cost_category
ORDER BY nb_product


-- organise the customer in category: VIP, regular, new
-- VIP: customer for at least 1 year and spending more than 6000
-- Regular: customer for at least 1 year spending less than 6000
-- new: customer for less than 1 year


WITH customer_order_info AS(
	SELECT 
		customer_key,
		SUM(sales_amount) as total_spent,
		MIN(order_date) as first_order_date,
		MAX(order_date) as last_order_date,
		DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) months_as_customer
	FROM gold.fact_sales
	GROUP BY customer_key
	HAVING MIN(order_date) IS NOT NULL

)
SELECT 
COUNT(customer_key) as nb_customer,
CASE
	WHEN total_spent >= 6000 AND months_as_customer >=12 THEN 'VIP'
	WHEN total_spent < 6000 AND months_as_customer >=12 THEN 'Regular'
	ELSE 'New'
END as customer_category
FROM customer_order_info
GROUP BY
	CASE
	WHEN total_spent >= 6000 AND months_as_customer >=12 THEN 'VIP'
	WHEN total_spent < 6000 AND months_as_customer >=12 THEN 'Regular'
	ELSE 'New'
	END 

