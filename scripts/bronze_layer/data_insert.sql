CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME
	BEGIN TRY
		PRINT '========================'
		PRINT ' PRINTING BRONZE LAYER'
		PRINT '========================'

		PRINT '------------------------'
		PRINT ' PRINTING CUST_INFO'
		PRINT '------------------------'

		SET @start_time=GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info
		BULK INSERT bronze.crm_cust_info
		FROM 'D:\Data-warehouse\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=','
		);
		SET @end_time=GETDATE();

		PRINT 'LOAD DURATION ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' SECONDS';

		PRINT '------------------------'
		PRINT ' PRINTING PRD_INFO'
		PRINT '------------------------'
		TRUNCATE TABLE bronze.crm_prd_info
		BULK INSERT bronze.crm_prd_info
		FROM 'D:\Data-warehouse\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=','
		);
		PRINT '------------------------'
		PRINT ' PRINTING SALES_DETAILS'
		PRINT '------------------------'
		TRUNCATE TABLE bronze.crm_sales_details
		BULK INSERT bronze.crm_sales_details
		FROM 'D:\Data-warehouse\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=','
		);
		PRINT '------------------------'
		PRINT ' PRINTING CUST_AZ12'
		PRINT '------------------------'
		TRUNCATE TABLE bronze.erp_cust_az12
		BULK INSERT bronze.erp_cust_az12
		FROM 'D:\Data-warehouse\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=','
		);
		PRINT '------------------------'
		PRINT ' PRINTING LOC_A101'
		PRINT '------------------------'
		TRUNCATE TABLE bronze.erp_loc_a101;
		BULK INSERT bronze.erp_loc_a101
		FROM 'D:\Data-warehouse\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=','
		);
		PRINT '------------------------'
		PRINT ' PRINTING PX_CAT_G1V2'
		PRINT '------------------------'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'D:\Data-warehouse\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=','
		);
	END TRY
	BEGIN CATCH
	PRINT '=================================='
	PRINT 'ERROR LOADING DATA IN BRONZE LAYER'
	PRINT 'ERROR MESSAGE'+ERROR_MESSAGE();
	PRINT 'ERROR NUMBER'+ERROR_NUMBER();
	PRINT '=================================='
	END CATCH
END