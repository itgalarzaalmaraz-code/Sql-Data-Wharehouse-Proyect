/*
=============================================================
Create stored procedure for the bronze layer
=============================================================
Purpose:
    This script is designed to load the raw data exactly as it comes from the 
    source systems. It allows us to maintain our own copy with our own metadata.

Description:
    Extracts data from the source system and loads it into the bronze layer 
    without applying any business transformations. Technical metadata is added 
    for audit and traceability purposes.
    
WARNING:
	Running this script will drop the entire 'load_bronze_layer' stored procedure if it exists.
	All logic of the stored procedure will be permanently deleted.
	Proceed with caution and ensure you have proper backups before running this script.
 */

-- =============================================================
-- Stored Procedure: bronze.load_bronze_layer
-- Description: Orchestrates the full raw data ingestion pipeline 
--              from CSV flat files into the Bronze layer tables 
--              using high-performance BULK INSERT operations.
-- Author: Data Engineering Team
-- =============================================================
CREATE OR ALTER PROCEDURE bronze.load_bronze_layer
AS
BEGIN
    -- Suppress row count metadata messages to optimize network traffic and logging
    SET NOCOUNT ON;

	BEGIN TRY
        -- =========================================================
        -- Global Pipeline Performance Variables
        -- =========================================================
		DECLARE @start_time DATETIME2(7);
		DECLARE @end_time DATETIME2(7);
		DECLARE @duration_seconds BIGINT;
	
        -- =========================================================
        -- 1. CRM: Customer Information Ingestion
        -- =========================================================
		SET @start_time = SYSDATETIME();
        
		-- Clear existing raw data to ensure a clean idempotent truncate-and-load cycle
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        
		-- Bulk load raw data from CSV source file
		BULK INSERT bronze.crm_cust_info
		FROM '/var/opt/mssql/datasets/source_crm/cust_info.csv'
		WITH (
		    FIRSTROW = 2,
		    FIELDTERMINATOR = ',',
    		ROWTERMINATOR = '\n',
		    TABLOCK
		);
		
		SET @end_time = SYSDATETIME();
		SET @duration_seconds = DATEDIFF_BIG(SECOND, @start_time, @end_time);
		PRINT 'Duration: ' + CAST(@duration_seconds AS VARCHAR(20)) + ' seconds';
		

        -- =========================================================
        -- 2. CRM: Product Information Ingestion
        -- =========================================================
		SET @start_time = SYSDATETIME();
        
		TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        
        BULK INSERT bronze.crm_prd_info
        FROM '/var/opt/mssql/datasets/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
		
		SET @end_time = SYSDATETIME();
		SET @duration_seconds = DATEDIFF_BIG(SECOND, @start_time, @end_time);
		PRINT 'Duration: ' + CAST(@duration_seconds AS VARCHAR(20)) + ' seconds';
	
		
        -- =========================================================
        -- 3. CRM: Sales Details Ingestion
        -- =========================================================
		SET @start_time = SYSDATETIME();
				
		TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        
        BULK INSERT bronze.crm_sales_details
        FROM '/var/opt/mssql/datasets/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
    		ROWTERMINATOR = '\n',
            TABLOCK
        );		
		
		SET @end_time = SYSDATETIME();
		SET @duration_seconds = DATEDIFF_BIG(SECOND, @start_time, @end_time);
		PRINT 'Duration: ' + CAST(@duration_seconds AS VARCHAR(20)) + ' seconds';	
		
		
        -- =========================================================
        -- 4. ERP: Customer Demographic Ingestion (AZ12)
        -- =========================================================
		SET @start_time = SYSDATETIME();
						
		TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>> Inserting Data Into: bronze.erp_CUST_AZ12';
        
        BULK INSERT bronze.erp_cust_az12
        FROM '/var/opt/mssql/datasets/source_erp/CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );			
		
		SET @end_time = SYSDATETIME();
		SET @duration_seconds = DATEDIFF_BIG(SECOND, @start_time, @end_time);
		PRINT 'Duration: ' + CAST(@duration_seconds AS VARCHAR(20)) + ' seconds';		
		
		
        -- =========================================================
        -- 5. ERP: Location/Geographical Ingestion (A101)
        -- =========================================================
		SET @start_time = SYSDATETIME();
						
		TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>> Inserting Data Into: bronze.erp_LOC_A101';
        
        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/datasets/source_erp/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );			
		
		SET @end_time = SYSDATETIME();
		SET @duration_seconds = DATEDIFF_BIG(SECOND, @start_time, @end_time);
		PRINT 'Duration: ' + CAST(@duration_seconds AS VARCHAR(20)) + ' seconds';
		
		
        -- =========================================================
        -- 6. ERP: Product Category Mapping Ingestion (G1V2)
        -- =========================================================
		SET @start_time = SYSDATETIME();		
								
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        
	    BULK INSERT bronze.erp_px_cat_g1v2
	    FROM '/var/opt/mssql/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
            TABLOCK
        );			
		
		SET @end_time = SYSDATETIME();
		SET @duration_seconds = DATEDIFF_BIG(SECOND, @start_time, @end_time);
		PRINT 'Duration: ' + CAST(@duration_seconds AS VARCHAR(20)) + ' seconds';
		
	END TRY
	BEGIN CATCH
        -- =========================================================
        -- Exception Management & Orchestrator Notification
        -- =========================================================
        PRINT '============================================';
        PRINT 'ERROR: Bronze Layer Load failed';
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
        PRINT '============================================';

        -- Propagate the error upward to alert the orchestration engine (e.g., Airflow)
        THROW;	
	END CATCH
END;
GO