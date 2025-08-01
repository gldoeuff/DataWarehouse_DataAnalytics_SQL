/*
=========================================
Ranking Analysis
========================================
Objective:
	-rank items based on performance 
	- identify the best and worst performers

*/

 --best 10 products
 SELECT TOP(10)
 dp.product_name,
SUM( sales_amount) as total_revenue
 FROM gold.fact_sales fs
 LEFT JOIN gold.dim_products dp
 ON fs.product_key=dp.product_key
 GROUP BY dp.product_name
 ORDER BY total_revenue DESC

 -- worst 10 products

 SELECT TOP(10)
 dp.product_name,
SUM( sales_amount) as total_revenue
 FROM gold.fact_sales fs
 LEFT JOIN gold.dim_products dp
 ON fs.product_key=dp.product_key
 GROUP BY dp.product_name
 ORDER BY total_revenue ASC


 -- top 10 customers
  SELECT TOP(10)
 dc.first_name,
 dc.last_name,
SUM( sales_amount) as total_revenue
 FROM gold.fact_sales fs
 LEFT JOIN gold.dim_customers dc
 ON fs.customer_key=dc.customer_key
 GROUP BY dc.customer_key, dc.first_name, dc.last_name
 ORDER BY total_revenue DESC

 -- bottom 10 customers
  SELECT TOP(10)
 dc.first_name,
 dc.last_name,
SUM( sales_amount) as total_revenue
 FROM gold.fact_sales fs
 LEFT JOIN gold.dim_customers dc
 ON fs.customer_key=dc.customer_key
 GROUP BY dc.customer_key, dc.first_name, dc.last_name
 ORDER BY total_revenue ASC

 -- top 5 customer with the more order

   SELECT TOP(5)
 dc.first_name,
 dc.last_name,
COUNT(fs.order_number) as total_orders
 FROM gold.fact_sales fs
 LEFT JOIN gold.dim_customers dc
 ON fs.customer_key=dc.customer_key
 GROUP BY dc.customer_key, dc.first_name, dc.last_name
 ORDER BY total_orders DESC