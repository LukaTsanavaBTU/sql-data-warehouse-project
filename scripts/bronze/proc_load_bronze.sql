/*

********************************
Stored Procedure: Load Bronze Layer (Source -> Bronze)
********************************

	Script Purpose:
		Load data into the 'bzonze' schema from external CSV files.
		Perform the following actions:
			- Truncate the bronze table before loading data.
			- Use 'BULT INSERT' command to load data from CSV files to bronze tables.

	Parameters:
		None (This stored procedure does not accept any parameters or return any values).

	Usage Example:
		EXEC bronze.load_bronze;

*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_time_total DATETIME, @end_time_total DATETIME;
	BEGIN TRY
		SET @start_time_total = GETDATE();
		PRINT '*************************************************';
		PRINT 'Loading Bronze Layer';
		PRINT '*************************************************';
		PRINT '------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info...';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data Into Table: bronze.crm_cust_info...'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\User\Desktop\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info...';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into Table: bronze.crm_prd_info...'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\User\Desktop\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details...';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into Table: bronze.crm_sales_details...'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\User\Desktop\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


		PRINT '------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12...';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into Table: bronze.erp_cust_az12...'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\User\Desktop\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101...';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into Table: bronze.erp_loc_a101...'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\User\Desktop\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2...';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into Table: bronze.erp_px_cat_g1v2...'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\User\Desktop\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		SET @end_time_total = GETDATE();
		PRINT '*************************************************';
		PRINT 'Finished Loading Bronze Layer';
		PRINT 'Total Duration: ' + CAST(DATEDIFF(second, @start_time_total, @end_time_total) AS NVARCHAR) + ' seconds';
		PRINT '*************************************************';
	END TRY
	BEGIN CATCH
		PRINT '*************************************************';
		PRINT 'AN ERROR HAS OCCURRED';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '*************************************************';
	END CATCH
END;
