/*
====================================================================================
DDL Script: Create Bronze Tables
====================================================================================
Purpose of the Script:
Creates tables in the "Bronze"schema with add logic to drop table it already exist
====================================================================================
*/

USE DataWarehouse
GO

IF OBJECT_ID ('Bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE Bronze.crm_cust_info;

CREATE TABLE Bronze.crm_cust_info (
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_material_status NVARCHAR(50),
cst_gnder NVARCHAR(50),
cst_create_date DATE

);

IF OBJECT_ID ('Bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE Bronze.crm_prd_info;

CREATE TABLE Bronze.crm_prd_info(
	prd_id int NULL,
	prd_key nvarchar(50) NULL,
	prd_nm nvarchar(50) NULL,
	prd_cost int NULL,
	prd_line nvarchar(50) NULL,
	prd_start_dt datetime NULL,
	prd_end_dt datetime NULL
);

IF OBJECT_ID ('Bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE Bronze.crm_sales_details;

	CREATE TABLE Bronze.crm_sales_details(
	sls_ord_nums nvarchar(50) NULL,
	sls_prd_key nvarchar(50) NULL,
	sls_cust_id int NULL,
	sls_order_dt int NULL,
	sls_ship_dt int NULL,
	sls_due_dt int NULL,
	sls_sales int NULL,
	sls_quantity int NULL,
	sls_price int NULL
);

IF OBJECT_ID ('Bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE Bronze.erp_cust_az12;

CREATE TABLE Bronze.erp_cust_az12(
	CID nvarchar(30) NULL,
	Bdate date NULL,
	Gen nvarchar(15) NULL
);

IF OBJECT_ID ('Bronze.erp_Loc_A101', 'U') IS NOT NULL
	DROP TABLE Bronze.erp_Loc_A101

CREATE TABLE Bronze.erp_Loc_A101(
	CID nvarchar(30) NULL,
	Cntry nvarchar(50) NULL
);

IF OBJECT_ID ('Bronze.px_cat_G1V2', 'U') IS NOT NULL
	DROP TABLE Bronze.px_cat_G1V2;

CREATE TABLE Bronze.px_cat_G1V2(
	ID nvarchar(10) NULL,
	Cat nvarchar(50) NULL,
	Subcat nvarchar(50) NULL,
	Maintenance nvarchar(50) NULL
);
