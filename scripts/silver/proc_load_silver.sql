
/*
==================================================
Stored Procedure: Load silver Layer ( bronze -> silver)
===================================================
Objective:
	This script procedure loads data into the 'silver' layer schema from the 'bronze layer'.
	It performs the following actions:
		- truncates the silver tables before loading the data
		- inserts transformed and cleansed data from Bronze in Silver tables

Parameters: 
	None

Example:
	EXEC silver.load_silver;

*/

CREATE OR ALTER PROCEDURE silver.load_silver AS

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_total DATETIME, @end_time_total DATETIME;
	BEGIN TRY

		SET @start_time_total=GETDATE();

		PRINT '========================';
		PRINT 'Loading silver Layer';
		PRINT '========================';


		PRINT '------------------------'
		PRINT 'Loading CRM Tables';
		PRINT '------------------------'

		SET @start_time= GETDATE();
		PRINT '>> Truncating table: silver.crm_cust_info'
		TRUNCATE TABLE silver.crm_cust_info;

		PRINT '>> Inserting Data into table: silver.crm_cust_info'
		INSERT INTO silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname, 
		cst_marital_status,
		cst_gndr, 
		cst_create_date)

		SELECT
		cst_id, 
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
			 WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
			 ELSE 'N/A'
		END cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
			 WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
			 ELSE 'N/A'
		END cst_gndr,
		cst_create_date
		FROM (
			SELECT
			*,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as  flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		)t
		WHERE flag_last=1
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';

		PRINT '---------------------------------------------------------'
		
		SET @start_time= GETDATE();
		PRINT '>> Truncating table: silver.crm_prd_info'
		TRUNCATE TABLE silver.crm_prd_info;

		PRINT '>> Inserting Data into table: silver.crm_prd_info'
		INSERT INTO silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
		)

		SELECT
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1,5) ,'-','_') as cat_id,
		SUBSTRING(prd_key, 7,LEN(prd_key)) as prd_key,
		prd_nm,
		ISNULL(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))	
			WHEN 'M' THEN 'Montain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'N/A'
		END AS prd_line,
		CAST(prd_start_dt AS DATE) AS prd_start_dt,
		CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)-1 AS DATE) AS prd_end_dt
		FROM bronze.crm_prd_info
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------'
		
		SET @start_time= GETDATE();
		PRINT '>> Truncating table: silver.crm_sales_details'
		TRUNCATE TABLE silver.crm_sales_details;

		PRINT '>> Inserting Data into table: silver.crm_sales_details'
		INSERT INTO silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt, 
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		)

		SELECT 
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt=0 OR LEN(sls_order_dt)!=8 THEN NULL
			ELSE CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE)
		END AS sls_order_dt,
		CASE WHEN sls_ship_dt=0 OR LEN(sls_ship_dt)!=8 THEN NULL
			ELSE CAST(CAST(sls_ship_dt AS NVARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE WHEN sls_due_dt=0 OR LEN(sls_due_dt)!=8 THEN NULL
			ELSE CAST(CAST(sls_due_dt AS NVARCHAR) AS DATE)
		END AS sls_due_dt,
		CASE WHEN sls_sales IS NULL OR sls_sales <=0  OR sls_sales!= sls_quantity * ABS(sls_price) 
			THEN sls_quantity*ABS(sls_price)
			ELSE sls_sales
		END as sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <=0
			THEN sls_sales/NULLIF(sls_quantity,NULL)
			ELSE sls_price
		END AS sls_price
		FROM bronze.crm_sales_details
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------'
		
		SET @start_time= GETDATE();
		PRINT '>> Truncating table: silver.erp_cust_az12'
		TRUNCATE TABLE silver.erp_cust_az12;

		PRINT '>> Inserting Data into table: silver.erp_cust_az12'
		INSERT INTO silver.erp_cust_az12(
		cid,
		bdate,
		gen
		)
		SELECT
		CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
			ELSE cid
		END cid,
		CASE WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END bdate,
		CASE WHEN TRIM(UPPER(gen)) IN ('M', 'MALE') THEN 'Male'
			 WHEN TRIM(UPPER(gen)) IN ('F', 'FEMALE') THEN 'Female'
			 ELSE 'N/A'
		END gen
		FROM bronze.erp_cust_az12

		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------'
		
		SET @start_time= GETDATE();
		PRINT '>> Truncating table: silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_loc_a101

		PRINT '>> Inserting Data into table: silver.erp_loc_a101'
		INSERT INTO silver.erp_loc_a101(
		cid,
		cntry
		)
		SELECT
		REPLACE(cid, '-', '') AS cid,
		CASE WHEN TRIM(cntry)='DE' THEN 'Germany'
			 WHEN TRIM(cntry) IN ('USA','US') THEN 'United States'
			 WHEN TRIM(cntry)='' OR cntry IS NULL THEN 'N/A'
			 ELSE cntry
		END AS cntry
		FROM bronze.erp_loc_a101

		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------'
		
		SET @start_time= GETDATE();
		PRINT '>> Truncating table: silver.erp_loc_a101'
		TRUNCATE TABLE silver.erp_px_cat_g1v2

		PRINT '>> Inserting Data into table: silver.erp_loc_a101'

		INSERT INTO silver.erp_px_cat_g1v2(
		id,
		cat,
		subcat,
		maintenance
		)
		SELECT * FROM bronze.erp_px_cat_g1v2

		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		SET @end_time_total=GETDATE();

		PRINT '=============================================================='
		PRINT 'Loading silver layer completed! ('+ CAST( DATEDIFF(second,@start_time_total,  @end_time_total) AS NVARCHAR) + ' seconds)';
		PRINT '=============================================================='
	END TRY

	BEGIN CATCH
	PRINT '============================================';
	PRINT 'Error occured while loading silver layer';
	PRINT 'Error Message:' + ERROR_MESSAGE();
	PRINT 'Error Number:' + CAST(ERROR_NUMBER() as NVARCHAR);
	PRINT '============================================';
	END CATCH
END
