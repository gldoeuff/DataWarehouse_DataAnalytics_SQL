/*
=========================
Magnitude Analysis
========================
Objective: 
	- quantify data by specific dimensions
	- understand data distribution across categories


*/

--total number of products per category
SELECT
category,
COUNT(product_key)
FROM gold.dim_products
GROUP BY category

-- average cost per category

SELECT
category,
AVG(cost)
FROM gold.dim_products
GROUP BY category

--total sales per category 
SELECT dp.category, SUM(fs.sales_amount) as total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key=dp.product_key
GROUP BY dp.category
ORDER BY total_sales DESC

--total sales per year

SELECT
YEAR (order_date) as sales_year,
SUM(sales_amount) as total_sales
FROM gold.fact_sales
GROUP BY YEAR (order_date)
ORDER BY YEAR(order_date)

-- total customer by country

SELECT 
country,
COUNT(customer_key)
FROM gold.dim_customers
GROUP BY country

--total revenue by country

SELECT
dc.country,
SUM(sales_amount) as total_revenue
FROM  gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key=dc.customer_key
GROUP BY dc.country
ORDER BY total_revenue DESC






-- total customer by gender

SELECT 
gender,
COUNT(customer_key)
FROM gold.dim_customers
GROUP BY gender

--total revenue by gender

SELECT
dc.gender,
SUM(sales_amount) as total_revenue
FROM  gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key=dc.customer_key
GROUP BY dc.gender
ORDER BY total_revenue DESC

-- total customer by marital status

SELECT 
marital_status,
COUNT(customer_key)
FROM gold.dim_customers
GROUP BY marital_status

--total revenue by marital status

SELECT
dc.marital_status,
SUM(sales_amount) as total_revenue
FROM  gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key=dc.customer_key
GROUP BY dc.marital_status
ORDER BY total_revenue DESC


--total revenue per customer
SELECT
dc.first_name,
dc.last_name,
SUM(sales_amount) as total_revenue
FROM  gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key=dc.customer_key
GROUP BY dc.customer_key, 
dc.first_name,
dc.last_name
ORDER BY total_revenue DESC

--total revenue by age categorie

SELECT
 CASE WHEN DATEDIFF(YEAR, birthdate, GETDATE()) >= 39 AND DATEDIFF(YEAR, birthdate, GETDATE()) < 59 THEN 'young'
	  WHEN DATEDIFF(YEAR, birthdate, GETDATE()) >= 59 AND DATEDIFF(YEAR, birthdate, GETDATE()) < 79 THEN 'medium'
	  WHEN DATEDIFF(YEAR, birthdate, GETDATE()) >= 79 THEN 'old'
	  ELSE 'N/A'
END as age_category,
SUM(sales_amount) as total_revenue
FROM gold.dim_customers dc
LEFT JOIN gold.fact_sales fs
ON dc.customer_key=fs.customer_key
GROUP BY   
	CASE WHEN DATEDIFF(YEAR, birthdate, GETDATE()) >= 39 AND DATEDIFF(YEAR, birthdate, GETDATE()) < 59 THEN 'young'
		  WHEN DATEDIFF(YEAR, birthdate, GETDATE()) >= 59 AND DATEDIFF(YEAR, birthdate, GETDATE()) < 79 THEN 'medium'
		  WHEN DATEDIFF(YEAR, birthdate, GETDATE()) >= 79 THEN 'old'
	ELSE 'N/A'
END
ORDER BY total_revenue DESC


