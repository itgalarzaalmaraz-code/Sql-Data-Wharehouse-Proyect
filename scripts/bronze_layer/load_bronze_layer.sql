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


-- Create Stored Procedure
CREATE OR ALTER PROCEDURE dbo.load_bronze_layer;
AS
BEGIN
	
	BULK INSERT 
	FROM 'ruta_del_archivo.csv'
	WITH (
	    FIRSTROW = 2,
	    FIELDTERMINATOR = ',',
	    ROWTERMINATOR = '0x0a',
	    CODEPAGE = '65001',
	    TABLOCK
	);
	
	
	
END;
GO




