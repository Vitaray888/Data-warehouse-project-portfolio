/*
============================================================================================
Stored Procedure: Load Bronze Layer (Bulk insert: Source -> Bronze)
============================================================================================
Script Purpose:
	Stored Procedure bulk loads data into the "Bronze" schema from external CSV files.
	The follow actions:
	- Truncates the bronze tables before loading data to ensure the latest will be loaded
	- Uses the "Bulk Insert" command to load data from CSV Files to bronze tables/schema
============================================================================================
*/

USE DataWarehouse
GO

--EXEC Bronze.load_bronze;

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS  -- SP TO EXCUTE SCRIPT
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_startime DATETIME, @batch_endtime DATETIME;
	BEGIN TRY
		SET @batch_startime = GETDATE();
		PRINT '====================================================================';
		PRINT 'Loading Bronze Layer'; -- This prints more detail when excuting script
		PRINT '====================================================================';

		PRINT '-------------------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_cust_info';
		TRUNCATE TABLE Bronze.crm_cust_info; -- Delete all rows before loading data

		PRINT '>> Inserting Data Into: Bronze.crm_cust_info';
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\Users\Data Engineering\Data Engineering\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'

		WITH (

		FIRSTROW = 2, -- Skip the first row in the file as we already defined the structure of our table, only the values
		FIELDTERMINATOR = ',', -- Define the Delimator the CSV File is being seperated by
		TABLOCK -- Place a table-level lock on the target table during the bulk load instead of locking individual rows or pages
		);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------';

		--*********************************************************************
		-- Bulk Insert Bronze.crm_prd_info
		--*********************************************************************

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_prd_info';
		TRUNCATE TABLE Bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: Bronze.crm_prd_info';
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\Users\Data Engineering\Data Engineering\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'

		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------';
		
		--*********************************************************************
		-- Bulk Insert crm_sales_details
		--*********************************************************************

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.crm_sales_details';
		TRUNCATE TABLE Bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: Bronze.crm_sales_details';
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\Users\Data Engineering\Data Engineering\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'

		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------';

		PRINT '-------------------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-------------------------------------------------------------------';

		
		--*********************************************************************
		-- Bulk Insert erp_cust_az12
		--*********************************************************************

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_cust_az12';
		TRUNCATE TABLE Bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: Bronze.erp_cust_az12';
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\Users\Data Engineering\Data Engineering\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'

		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK

		);

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------';

		
		--*********************************************************************
		-- Bulk Insert erp_Loc_A101
		--*********************************************************************

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_Loc_A101';
		TRUNCATE TABLE Bronze.erp_Loc_A101

		PRINT '>> Inserting Data Into: Bronze.erp_Loc_A101';
		BULK INSERT Bronze.erp_Loc_A101
		FROM 'C:\Users\Data Engineering\Data Engineering\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'

		WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST( DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------';

		
		--*********************************************************************
		-- Bulk Insert erp_px_cat_G1V2
		--*********************************************************************

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: Bronze.erp_px_cat_G1V2';
		TRUNCATE TABLE Bronze.erp_px_cat_G1V2;

		PRINT '>> Inserting Data Into: Bronze.erp_px_cat_G1V2';
		BULK INSERT Bronze.erp_px_cat_G1V2
		FROM 'C:\Users\Data Engineering\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'

		WITH (

		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
		SET @batch_endtime = GETDATE();
		PRINT '===========================================================================';
		PRINT 'Loading Bronze Layer is Completed:';
		PRINT '    - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_startime, @batch_endtime) AS NVARCHAR) + ' seconds';
		PRINT '===========================================================================';
	END TRY

	BEGIN CATCH
		PRINT '============================================================================';
		PRINT 'ERROR OCCURED DURING BRONZE LAYER LOAD';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '============================================================================';

	END CATCH

END;

--SELECT COUNT(*) FROM Bronze.erp_px_cat_G1V2
