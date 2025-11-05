/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
Go
  -- Drop and recreate the 'Datawherehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASES DataWarehouse;
END;
GO

-- create the DataWarehouse database
CREATE DATABASE DataWarehouse;
GO
  
USE DataWarehouse;
GO
  
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO

/* create tables and fields (for crm and erp) */

IF object_id ('bronze.crm_cust_info', 'u') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);
IF object_id('bronze.crm_prd_info','u') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
create table bronze.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATETIME,
prd_end_dt DATETIME,
);
GO
IF object_id('bronze.crm_sales_details','u') IS NOT NULL
DROP TABLE bronze.crm_sales_details;
create table bronze.crm_sales_details (
sls_ord_num NVARCHAR(50),
sls_prd_key NVARCHAR(50),
sls_cust_id  INT,	
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);
GO
IF object_id('bronze.erp_loc_a101','u') IS NOT NULL
DROP TABLE bronze.erp_loc_a101;
create table bronze.erp_loc_a101(
cid NVARCHAR(50),
CNTRY NVARCHAR(50)
);
GO
IF object_id('bronze.erp_cust_az12','u') IS NOT NULL
DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
cid nvarchar(50),
bdate DATE,
gen NVARCHAR(50)
);
GO

IF object_id ('bronze.erp_px_cat_g1v2', 'u') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2(
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50)
);

/* Now load the bulk data into a table before inserting you need to TRUNCATE table so that when you run again load it not be overwrite */

TRUNCATE TABLE bronze.crm_cust_info;
BULK insert bronze.crm_cust_info
	FROM 'E:\Data-Engineer\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info 
	FROM 'E:\Data-Engineer\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK);

TRUNCATE TABLE bronze.crm_sales_details;
BULK INSERT bronze.crm_sales_details 
	FROM 'E:\Data-Engineer\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH
	(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK);

TRUNCATE TABLE bronze.erp_cust_az12;
BULK INSERT bronze.erp_cust_az12
FROM 'E:\Data-Engineer\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

TRUNCATE TABLE bronze.erp_loc_a101;
BULK INSERT bronze.erp_loc_a101
FROM 'E:\Data-Engineer\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

TRUNCATE TABLE bronze.erp_px_cat_g1v2;
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'E:\Data-Engineer\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);
