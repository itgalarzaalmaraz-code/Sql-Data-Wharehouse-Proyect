/*
=============================================================
Create a stored procedure for the Bronze layer structure.
=============================================================
Purpose:

    This script creates the structure of the Bronze layer,
    where raw data is initially loaded from source systems.

Description:

    Extracts data from source systems and loads it into the
    Bronze layer without applying any transformations.

    Technical metadata is added for auditing and traceability
    purposes.

WARNING:

    Executing this script will drop the existing stored procedure
    'ddl_bronze_layer' if it exists.

    All logic within the stored procedure will be permanently
    deleted.

    Proceed with caution and ensure that proper backups are
    available before executing this script.
*/

-- Ensure that the script is executed in the appropriate database.
USE DataWarehouse_Personal;
GO

-- =============================================================
-- Stored Procedure: bronze.ddl_bronze_layer
-- Description: Drops and recreates the physical DDL structures 
--              for all raw CRM and ERP tables in the Bronze layer.
-- Author: Data Engineering Student Alvaro Santiago Galarza Almaraz
-- =============================================================
CREATE OR ALTER PROCEDURE bronze.ddl_bronze_layer
AS
BEGIN
    -- Prevent implicit transaction issues and optimize message flow
    SET NOCOUNT ON;

    BEGIN TRY
        -- =========================================================
        -- 1. Execution Control & Audit Variables Initialization
        -- =========================================================
        DECLARE @start_time DATETIME2(7);
        DECLARE @end_time DATETIME2(7);
        DECLARE @duration_seconds BIGINT;
            
        -- Capture the exact start timestamp of the DDL execution pipeline
        SET @start_time = SYSDATETIME();    
    
        -- Log pipeline initialization banner
        PRINT '====================================================================';
        PRINT 'PROCEDIMIENTO: bronze.ddl_bronze_layer';
        PRINT 'INFO: Starting the provisioning of Bronze Layer structures';
        PRINT '====================================================================';
        
        -- =========================================================
        -- 2. CRM Source Tables Provisioning
        -- =========================================================

        -- Drop existing customer info table to ensure idempotent DDL execution
        DROP TABLE IF EXISTS bronze.crm_cust_info;
        
        -- Create raw customer information table from CRM
        CREATE TABLE bronze.crm_cust_info (
            cst_id INT,
            cst_key VARCHAR(30),
            cst_firstname VARCHAR(20),
            cst_lastname VARCHAR(20),
            cst_marital_status VARCHAR(5),
            cst_gndr VARCHAR(5),
            cst_create_date DATETIME
        );
        
        -- Drop existing product info table
        DROP TABLE IF EXISTS bronze.crm_prd_info;
        
        -- Create raw product information table from CRM
        CREATE TABLE bronze.crm_prd_info (
            prd_id INT,
            prd_key VARCHAR(50),
            prd_nm VARCHAR(50),
            prd_cost INT,
            prd_line VARCHAR(5),
            prd_start_dt DATETIME,
            prd_end_dt DATETIME
        );
            
        -- Drop existing sales details table
        DROP TABLE IF EXISTS bronze.crm_sales_details;
            
        -- Create raw sales transactions details table from CRM
        CREATE TABLE bronze.crm_sales_details (
           sls_ord_num VARCHAR(30),
           sls_prd_key VARCHAR(30),
           sls_cust_id INT,
           sls_order_dt INT,
           sls_ship_dt INT,
           sls_due_dt INT,
           sls_sales INT,
           sls_quantity INT,
           sls_price INT
        );
        
        -- =========================================================
        -- 3. ERP Source Tables Provisioning
        -- =========================================================

        -- Drop existing ERP customer demographic table
        DROP TABLE IF EXISTS bronze.erp_cust_az12;
        
        -- Create raw customer demographic table from ERP
        CREATE TABLE bronze.erp_cust_az12 (
            CID VARCHAR(30),
            BDATE DATE,
            GEN VARCHAR(10)
        );
        
        -- Drop existing ERP location table
        DROP TABLE IF EXISTS bronze.erp_loc_a101;
        
        -- Create raw location/geographical table from ERP
        CREATE TABLE bronze.erp_loc_a101 (
            CID VARCHAR(30),
            CNTRY VARCHAR(50)
        );
        
        -- Drop existing ERP product category table
        DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
            
        -- Create raw product category mapping table from ERP
        CREATE TABLE bronze.erp_px_cat_g1v2 (
            ID VARCHAR(20),
            CAT VARCHAR(50),
            SUBCAT VARCHAR(50),
            MAINTENANCE VARCHAR(5)
        );
            
        -- =========================================================
        -- 4. Execution Metrics & Completion Logging
        -- =========================================================
        SET @end_time = SYSDATETIME();
        SET @duration_seconds = DATEDIFF_BIG(SECOND, @start_time, @end_time);
        
        PRINT '====================================================================';
        PRINT 'SUCCESS: Bronze Layer DDL successfully provisioned.';
        PRINT 'Execution Duration: ' + CAST(@duration_seconds AS VARCHAR(20)) + ' seconds';
        PRINT '====================================================================';
    
    END TRY
    BEGIN CATCH
        -- =========================================================
        -- 5. Exception Management & Error Handling
        -- =========================================================
        PRINT '============================================================';
        PRINT 'ERROR: Bronze Layer DDL deployment failed.';
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
        PRINT '============================================================';

        -- Re-raise the exception to alert orchestrator tools (e.g., Airflow, SSIS)
        THROW;
    END CATCH;
END;
GO