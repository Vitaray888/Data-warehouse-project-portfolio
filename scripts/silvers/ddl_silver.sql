/*
============================================================================
DDL Script: Create Silver Tables
============================================================================
Purpose of the Script:
Creates tables in the "Silver"schema with add logic to drop table it already exist
============================================================================
Metadata Columns:
Extra Columns added by the Data Engineer that do not originate from the source data.

Example:
create_date: The record's load timestampe.
update_date: The record's last update timestamp.
source_systems: The origin system of the recode

*/

USE DataWarehouse
GO

IF OBJECT_ID ('Silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE Silver.crm_cust_info;

CREATE TABLE Silver.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gnder NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID ('Silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE Silver.crm_prd_info;

CREATE TABLE Silver.crm_prd_info(
	prd_id int NULL,
	prd_key nvarchar(50) NULL,
	prd_nm nvarchar(50) NULL,
	prd_cost int NULL,
	prd_line nvarchar(50) NULL,
	prd_start_dt datetime NULL,
	prd_end_dt datetime NULL,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('Silver.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE Silver.crm_sales_details;

	CREATE TABLE Silver.crm_sales_details(
	sls_ord_nums nvarchar(50) NULL,
	sls_prd_key nvarchar(50) NULL,
	sls_cust_id int NULL,
	sls_order_dt int NULL,
	sls_ship_dt int NULL,
	sls_due_dt int NULL,
	sls_sales int NULL,
	sls_quantity int NULL,
	sls_price int NULL,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('Silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE Silver.erp_cust_az12;

CREATE TABLE Silver.erp_cust_az12(
	CID nvarchar(30) NULL,
	Bdate date NULL,
	Gen nvarchar(15) NULL,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('Silver.erp_Loc_A101', 'U') IS NOT NULL
	DROP TABLE Silver.erp_Loc_A101

CREATE TABLE Silver.erp_Loc_A101(
	CID nvarchar(30) NULL,
	Cntry nvarchar(50) NULL,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('Silver.px_cat_G1V2', 'U') IS NOT NULL
	DROP TABLE Silver.px_cat_G1V2;

CREATE TABLE Silver.px_cat_G1V2(
	ID nvarchar(10) NULL,
	Cat nvarchar(50) NULL,
	Subcat nvarchar(50) NULL,
	Maintenance nvarchar(50) NULL,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
