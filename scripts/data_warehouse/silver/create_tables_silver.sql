/*
============================================
DDL Script: Create silver layer tables
============================================
Objective:
	This script create the tables in the 'silver' schema, 
	dropping the existing table if they already exist.
============================================
*/

-- delete crm_cust_info table if it exists
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info

-- create table in crm_cust_info in silver schema
CREATE TABLE silver.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()

);


-- delete crm_prd_info table if it exists
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info

-- create table in crm_prd_info in silver schema
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,	
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);


-- delete crm_sales_details table if it exists
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE silver.crm_sales_details
	
-- create table in crm_sales_details in silver schema
CREATE TABLE silver.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,	
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- delete erp_cust_az12 table if it exists
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12

-- create table in erp_cust_az12 in silver schema
CREATE TABLE silver.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50),	
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- delete erp_loc_a101 table if it exists
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101

-- create table in erp_loc_a101 in silver schema
CREATE TABLE silver.erp_loc_a101(
	cid NVARCHAR(50),	
	cntry NVARCHAR(50),	
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- delete erp_px_cat_g1v2 table if it exists
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2

-- create table in erp_px_cat_g1v2 in silver schema
CREATE TABLE silver.erp_px_cat_g1v2(
	id NVARCHAR(50),	
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50),	
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
