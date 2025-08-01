/*
===================================================
Performance Analysis
============================================
Objective:
	-measure the performance of product, customer, country over time
	-identify high performing items
	- track trend and growth over time
=================================================
*/

-- calculate the total revenue of each product for each year, the yearly average revenue and compare the yearly revenue of each product with the average


WITH yearly_product_revenue AS (
	SELECT
	dp.product_name,
	YEAR(fs.order_date) as order_year,
	SUM(fs.sales_amount) as yearly_revenue
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products dp
	ON fs.product_key= dp.product_key
	WHERE fs.order_date IS NOT NULL
	GROUP BY dp.product_name, YEAR(fs.order_date)
)


SELECT
	product_name,
	order_year,
	yearly_revenue,
	-- calculate yearly average
	AVG(yearly_revenue) OVER( PARTITION BY product_name) as yearly_average_revenue,
	--
	-- comparaison to  yearly average
	yearly_revenue - AVG(yearly_revenue) OVER( PARTITION BY product_name) as diff_revenue,	
	CASE WHEN yearly_revenue - AVG(yearly_revenue) OVER( PARTITION BY product_name) > 0 THEN '+'
		 WHEN yearly_revenue - AVG(yearly_revenue) OVER( PARTITION BY product_name) < 0 THEN '-'
		 ELSE '='
	END as performance	,
	--
	-- comparaison to the previous year
	LAG(yearly_revenue) OVER (PARTITION BY product_name ORDER BY order_year) as prev_year_revenue,
	CASE
		WHEN LAG(yearly_revenue) OVER (PARTITION BY product_name ORDER BY order_year) IS NOT NULL 
			THEN	yearly_revenue -LAG(yearly_revenue) OVER (PARTITION BY product_name ORDER BY order_year)
		ELSE 0
	END as growth_revenue,
	CASE
		WHEN yearly_revenue -LAG(yearly_revenue) OVER (PARTITION BY product_name ORDER BY order_year) > 0
			THEN	'Increase'
		WHEN  yearly_revenue -LAG(yearly_revenue) OVER (PARTITION BY product_name ORDER BY order_year) < 0
			THEN	'Decrease'
		ELSE 'Same'
	END as growth_revenue	
	--
FROM yearly_product_revenue
ORDER BY 1,2