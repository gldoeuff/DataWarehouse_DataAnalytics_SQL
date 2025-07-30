/*
================================================
DLL Scripts: Create Gold Views
================================================
Objective:
This script creates views for the gold layer in the data warehouse
the gold layer represents the final dimension and fact tables ( Star Schema)

Each views perfoms transformations and combines data from the silver layer
to produce clean enrichedm and business-ready dataset
==========================================================
*/

-- Create dimension : gold.dim_customers

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers
GO


CREATE VIEW gold.dim_customers AS
SELECT 
ROW_NUMBER() OVER (ORDER BY cst_id) as customer_key, -- surrogate key
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
la.cntry AS country,
ci.cst_marital_status AS marital_status,
CASE WHEN ci.cst_gndr!='N/A' THEN ci.cst_gndr -- CRM is the Master
	 ELSE COALESCE(ca.gen, 'N/A')
END AS gender,
ca.bdate AS birthdate,
ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN  silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key= la.cid
GO


-- Create dimension : gold.dim_products

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products
GO

CREATE VIEW gold.dim_products AS
SELECT 
ROW_NUMBER() OVER ( ORDER BY pif.prd_start_dt, pif.prd_key) as product_key,
pif.prd_id AS product_id,
pif.prd_key as product_number,
pif.prd_nm as product_name,
pif.cat_id as category_id,
pca.cat as category,
pca.subcat as subcategory,
pca.maintenance,
pif.prd_cost as cost,
pif.prd_line as product_line,
pif.prd_start_dt as start_date
FROM silver.crm_prd_info pif
LEFT JOIN silver.erp_px_cat_g1v2 pca
ON pif.cat_id=pca.id
WHERE prd_end_dt IS NULL ;-- to get only the current products
GO

-- Create fact : gold.fact_sales

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales
GO

CREATE VIEW gold.fact_sales AS

SELECT 
sd.sls_ord_num as order_number,
dp.product_key,
dc.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as shipping_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount,
sd.sls_quantity as quantity,
sd.sls_price as price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_customers dc
ON sd.sls_cust_id=dc.customer_id
LEFT JOIN gold.dim_products dp
ON sd.sls_prd_key=dp.product_number
GO
