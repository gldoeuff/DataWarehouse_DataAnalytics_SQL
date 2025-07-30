
/*
===================================================
Quality checks
=================================================
Objective:
	This script performs various quality checks for data consistency, accurax, and standardization
	across the 'silver' schemas:
	- Null or duplicate primary keys
	- Unwanted space in string  fields
	- Data standardization and consistency
	- invalid date range and order
	- data consistency between related field

Note:
	- Run it after the loading of the silver layer
============================================================================================
*/

--********************************
-- Checking 'silver.crm_cust_info
--********************************


-- Checks for Null or Duplicate in Primary Key
-- Expectation: No result

SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- check or unwanted spaces
-- Expectation: no results

SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Data standardization & consistency
-- Expectation: Single, Married, N/A

SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

--********************************
-- Checking 'silver.crm_prod_info
--********************************

-- Checks for Null or Duplicate in Primary Key
-- Expectation: No result

SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- check or unwanted spaces
-- Expectation: no results

SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- check for Null or negative values in cost
-- Expectation: no results

SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Data standardization & consistency
-- Expectation: Montain, N/A, Other Sales, Road, Touring

SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- check for invalid date order
--Expectation: no result

SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


--********************************
-- Checking 'silver.crm_sales_details
--********************************

-- check for invalid dates ( 
--Expectation: no result


SELECT 
  sls_due_dt
FROM silver.crm_sales_details
WHERE CAST(sls_due_dt AS DATE)  < '1900-09-08'
OR CAST(sls_due_dt AS DATE)  > '2050-01-01'

SELECT 
  sls_ship_dt
FROM silver.crm_sales_details
WHERE CAST(sls_ship_dt AS DATE)  < '1900-09-08'
OR CAST(sls_ship_dt AS DATE)  > '2050-01-01'


SELECT 
  sls_order_dt
FROM silver.crm_sales_details
WHERE CAST(sls_order_dt AS DATE)  < '1900-09-08'
OR CAST(sls_order_dt AS DATE)  > '2050-01-01'



-- check for invalid date order ( order date < shipping < due date)
--Expectation : no result

SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt
   OR sls_ship_dt > sls_due_dt;

-- check data consistency: Sales= Quantify * Price
-- Expectation: no result

SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


--********************************
-- Checking 'silver.erp_cust_az12'
--********************************

-- Identify Out-of-Range Dates
-- Expectation: no results

SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1900-01-01' 
   OR bdate > GETDATE();

-- Data Standardization & Consistency
--Expectation: N/A, Male, Female

SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

--********************************
-- Checking 'silver.erp_loc_a101'
--********************************

-- Data Standardization & Consistency
-- Expectation: Australia, Canada, France, Germany, N/A, United Kingdom, United States


SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

--********************************
-- Checking 'silver.erp_px_cat_g1v2'
--********************************

-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Data Standardization & Consistency
-- Expectation: No, Yes

SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
