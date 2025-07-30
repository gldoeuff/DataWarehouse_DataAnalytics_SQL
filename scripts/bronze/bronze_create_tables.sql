/*
============================================
DDL Script: Create Bronze layer tables
============================================
Objective:
	This script create the tables in the 'bronze' schema, 
	dropping the existing table if they already exist.
============================================
*/

-- delete crm_cust_info table if it exists
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info

-- create table in crm_cust_info in bronze schema
CREATE TABLE bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);


-- delete crm_prd_info table if it exists
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info

-- create table in crm_prd_info in bronze schema
CREATE TABLE bronze.crm_prd_info(
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);


-- delete crm_sales_details table if it exists
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details
	
-- create table in crm_sales_details in bronze schema
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

-- delete erp_cust_az12 table if it exists
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12

-- create table in erp_cust_az12 in bronze schema
CREATE TABLE bronze.erp_cust_az12(
	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
);

-- delete erp_loc_a101 table if it exists
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101

-- create table in erp_loc_a101 in bronze schema
CREATE TABLE bronze.erp_loc_a101(
	cid NVARCHAR(50),	
	cntry NVARCHAR(50)
);

-- delete erp_px_cat_g1v2 table if it exists
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2

-- create table in erp_px_cat_g1v2 in bronze schema
CREATE TABLE bronze.erp_px_cat_g1v2(
	id NVARCHAR(50),	
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50),
);
