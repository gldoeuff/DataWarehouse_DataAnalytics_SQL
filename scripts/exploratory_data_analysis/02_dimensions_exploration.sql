/*
===========================================
Dimensions Exploration
=======================================
Objective:
	- explore the structure of the dimension table

*/

-----------------------------
--customer table: dim_customers
-----------------------------

--get an overall overview of the table 
SELECT TOP(500) *  FROM gold.dim_customers;

--get the list of countries
SELECT DISTINCT country FROM gold.dim_customers;

--get list of marital status
SELECT DISTINCT marital_status FROM gold.dim_customers;

--get list of gender
SELECT DISTINCT gender FROM gold.dim_customers;


-----------------------------
--products table: dim_products
-----------------------------

--get an overall overview of the table 
SELECT TOP(500) *  FROM gold.dim_products;

--get list of category , subcategory, product name
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY category, subcategory, product_name

-- get list of the product line
SELECT DISTINCT product_line, product_name
FROM gold.dim_products
ORDER BY product_line, product_name