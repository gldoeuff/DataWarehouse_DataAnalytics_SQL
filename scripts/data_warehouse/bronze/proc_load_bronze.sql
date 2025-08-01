/*
==================================================
Stored Procedure: Load Bronze Layer ( Source -> Bronze)
===================================================
Objective:
	This script procedure loads data into the 'bronze' layer schema from external csv files.
	It performs the following actions:
		- truncates the bronze tables before loading the data
		- uses the 'BULK INSERT' commannd to load data from csv files

Parameters: 
	None

Example:
	EXEC bronze.load_bronze;

*/





-- full load in the bronze table

CREATE OR ALTER PROCEDURE bronze.load_bronze AS

BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_total DATETIME, @end_time_total DATETIME;
	BEGIN TRY

		SET @start_time_total=GETDATE();

		PRINT '========================';
		PRINT 'Loading Bronze Layer';
		PRINT '========================';

		PRINT '------------------------'
		PRINT 'Loading CRM Tables';
		PRINT '------------------------'
		--crm_cust_info-------------------------------------------------------------------------
		SET @start_time= GETDATE();
		PRINT '>> Truncating the table: bronze.crm_cust_info';
		-- erase the data inside the table before bulk insert
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data into the table: bronze.crm_cust_info';
		-- insert the data in the table from the csv file
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\ledoe\OneDrive\Dokumente\2-Education\course\DataWithBaraa\SQL\DataWarehouseProject\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>>-----------------';

		--crm_prd_info-----------------------------------------------------------------------------
		SET @start_time= GETDATE();
		PRINT '>> Truncating the table: bronze.crm_prd_info';
		-- erase the data inside the table before bulk insert
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data into the table: bronze.crm_prd_info';
		-- insert the data in the table from the csv file
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\ledoe\OneDrive\Dokumente\2-Education\course\DataWithBaraa\SQL\DataWarehouseProject\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>>-----------------';


		--crm_sales_detailes---------------------------------------------------------------------------------------------
		SET @start_time= GETDATE();
		PRINT '>> Truncating the table: bronze.crm_sales_details';
		-- erase the data inside the table before bulk insert
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data into the table: bronze.crm_sales_details';
		-- insert the data in the table from the csv file
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\ledoe\OneDrive\Dokumente\2-Education\course\DataWithBaraa\SQL\DataWarehouseProject\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>>-----------------';

		PRINT '------------------------'
		PRINT 'Loading ERP Tables';
		PRINT '------------------------'

		--erp_cust_az12---------------------------------------------------------------------------------------------
		SET @start_time= GETDATE();
		PRINT '>> Truncating the table: bronze.erp_cust_az12';
		-- erase the data inside the table before bulk insert
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data into the table: bronze.erp_cust_az12';
		-- insert the data in the table from the csv file
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\ledoe\OneDrive\Dokumente\2-Education\course\DataWithBaraa\SQL\DataWarehouseProject\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>>-----------------';



		--erp_loc_a101---------------------------------------------------------------------------------------------
		SET @start_time= GETDATE();
		PRINT '>> Truncating the table: bronze.erp_loc_a101';
		-- erase the data inside the table before bulk insert
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data into the table: bronze.erp_loc_a101';
		-- insert the data in the table from the csv file
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\ledoe\OneDrive\Dokumente\2-Education\course\DataWithBaraa\SQL\DataWarehouseProject\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>>-----------------';

		--erp_px_cat_g1v2---------------------------------------------------------------------------------------------
		SET @start_time= GETDATE();
		PRINT '>> Truncating the table: bronze.erp_px_cat_g1v2';
		-- erase the data inside the table before bulk insert
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data into the table: bronze.erp_px_cat_g1v2';
		-- insert the data in the table from the csv file
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\ledoe\OneDrive\Dokumente\2-Education\course\DataWithBaraa\SQL\DataWarehouseProject\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT '>> Load duration: '+ CAST( DATEDIFF(second,@start_time,  @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>>-----------------';

		SET @end_time_total=GETDATE();

		PRINT '=============================================================='
		PRINT 'Loading Bronze layer completed! ('+ CAST( DATEDIFF(second,@start_time_total,  @end_time_total) AS NVARCHAR) + ' seconds)';
		PRINT '=============================================================='

	END TRY

	BEGIN CATCH
		PRINT '============================================';
		PRINT 'Error occured while loading Bronze layer';
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Number:' + CAST(ERROR_NUMBER() as NVARCHAR);
		PRINT '============================================';
	END CATCH
END
