EXEC Silver.sp_load_silver 

CREATE OR ALTER PROCEDURE Silver.sp_load_silver AS
BEGIN

DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
BEGIN TRY
    SET @batch_start_time = GETDATE()

PRINT '================================================================';
PRINT 'Loading Silver Layer';
PRINT '================================================================';

PRINT '----------------------------------------------------------------';
PRINT 'Loading CRM Tables';
PRINT '----------------------------------------------------------------';

/***********************************************************************
----------------------- Silver.crm_cust_info --------------------------
***********************************************************************/

SET @start_time = GETDATE();
PRINT '>> Truncating Table: Silver.crm_cust_info';
TRUNCATE TABLE Silver.crm_cust_info

PRINT '>> Inserting Data Into: Silver.crm_cust_info';
-- ROW_NUMBER(): Assisngs a unique number to each row in a result set, based on a defined order

INSERT INTO Silver.crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gnder,
cst_create_date

)

SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,

CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
     WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
     ELSE 'n/a'
END AS cst_marital_status,

CASE WHEN UPPER(TRIM(cst_gnder)) = 'M' THEN 'Male'
     WHEN UPPER(TRIM(cst_gnder)) = 'F' THEN 'Female'
     ELSE 'n/a'
END AS cst_gnder,
cst_create_date

FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY cst_id 
               ORDER BY cst_create_date DESC
           ) AS Flag_list
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE Flag_list = 1;

SET @end_time = GETDATE()
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds'
PRINT '>> --------------';

/***********************************************************************
----------------------- Silver.crm_prd_info --------------------------
***********************************************************************/

SET @start_time = GETDATE();
PRINT '>> Truncating Table: Silver.crm_prd_info';
TRUNCATE TABLE Silver.crm_prd_info

PRINT '>> Inserting Data Into: Silver.crm_prd_info';
-- INSERT DATA INTO TABLE

INSERT INTO Silver.crm_prd_info (
    prd_id,
    cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)

-- DATA NORMALIZATION AND STANDARDIZATION

SELECT [prd_id]
      ,REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id
      ,SUBSTRING(prd_key, 7,len(prd_key)) AS prd_key
      ,[prd_nm]
      ,ISNULL([prd_cost], 0) AS prd_cost
      ,CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
      ELSE 'n/a' END AS [prd_line]
      ,CAST([prd_start_dt] AS DATE) AS prd_start_dt
      ,CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS DATE) AS [prd_end_dt]
  FROM [DataWarehouse].[Bronze].[crm_prd_info]

    SET @end_time = GETDATE()
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds'
    PRINT '>> --------------';

  --WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') NOT IN
  --(SELECT DISTINCT id from Bronze.erp_px_cat_G1V2);


/***********************************************************************
--------------------- Silver.crm_sales_details-------------------------
***********************************************************************/

SET @start_time = GETDATE();
PRINT '>> Truncating Table: Silver.crm_sales_details';
TRUNCATE TABLE Silver.crm_sales_details

PRINT '>> Inserting Data Into: Silver.crm_sales_details';
-- INSERT DATA INTO TABLE

INSERT INTO Silver.crm_sales_details (
     sls_ord_nums,
     sls_prd_key,
     sls_cust_id,
     sls_order_dt,
     sls_ship_dt,
     sls_due_dt,
     sls_sales,
     sls_quantity,
     sls_price
)

SELECT 
    [sls_ord_nums]
   ,[sls_prd_key]
   ,[sls_cust_id]
   ,CASE
        WHEN sls_order_dt = 0 or len(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
    END AS sls_order_dt
      
    ,CASE
        WHEN sls_ship_dt = 0 or len(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
    END AS sls_ship_dt

     ,CASE
        WHEN sls_due_dt = 0 or len(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
    END AS sls_due_dt

    ,CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	    THEN sls_quantity * ABS(sls_price)
	    ELSE sls_sales
    END AS sls_sales

   ,[sls_quantity]
   ,CASE WHEN sls_price IS NULL OR sls_price <=0
	    THEN sls_price / NULLIF(sls_quantity, 0)
	    ELSE sls_price
    END AS sls_price

  FROM [DataWarehouse].[Bronze].[crm_sales_details]

  SET @end_time = GETDATE()
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds'
PRINT '>> --------------';


PRINT '----------------------------------------------------------------';
PRINT 'Loading CRM Tables';
PRINT '----------------------------------------------------------------';


/***********************************************************************
---------------------- Silver.erp_cust_az12 ---------------------------
***********************************************************************/

SET @start_time = GETDATE();
PRINT '>> Truncating Table: Silver.erp_cust_az12';
TRUNCATE TABLE Silver.erp_cust_az12

PRINT '>> Inserting Data Into: Silver.erp_cust_az12';
-- INSERT DATA INTO TABLE

INSERT INTO Silver.erp_cust_az12 (
	
	CID
   ,Bdate
   ,Gen

)

SELECT 
 CASE 
	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
 END AS cid
,CASE WHEN bdate > GETDATE() THEN NULL 
	ELSE bdate
END AS bdate

,CASE WHEN UPPER(TRIM(Gen)) IN ('F', 'FEMALE') THEN 'Female'
	  WHEN UPPER(TRIM(Gen)) IN ('M', 'MALE') THEN 'Male'
	  ELSE 'n/a'
 END AS Gen
 
FROM [DataWarehouse].[Bronze].[erp_cust_az12]

SET @end_time = GETDATE()
PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds'
PRINT '>> --------------';


/***********************************************************************
----------------------- Silver.erp_Loc_A101 --------------------------
***********************************************************************/

SET @start_time = GETDATE();
PRINT '>> Truncating Table: Silver.erp_Loc_A101';
TRUNCATE TABLE Silver.erp_Loc_A101

PRINT '>> Inserting Data Into: Silver.erp_Loc_A101';
-- INSERT DATA INTO TABLE

INSERT INTO Silver.erp_Loc_A101 (CID, Cntry)

SELECT 
       REPLACE([CID], '-', '') AS CID
       ,CASE
            WHEN TRIM(Cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(Cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(Cntry) = '' OR Cntry IS NULL THEN 'n/a'
        ELSE TRIM(Cntry)
        END AS Cntry
  
  FROM [DataWarehouse].[Bronze].[erp_Loc_A101]

    SET @end_time = GETDATE()
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds'
    PRINT '>> --------------';

  
/***********************************************************************
----------------------- Silver.erp_px_cat_G1V2 --------------------------
***********************************************************************/

SET @start_time = GETDATE();
PRINT '>> Truncating Table: Silver.erp_px_cat_G1V2';
TRUNCATE TABLE Silver.erp_px_cat_G1V2

PRINT '>> Inserting Data Into: Silver.erp_px_cat_G1V2';
-- INSERT DATA INTO TABLE

INSERT INTO Silver.erp_px_cat_G1V2 (ID, Cat, Subcat, Maintenance)

SELECT 
       ID
      ,Cat
      ,Subcat
      ,Maintenance
  FROM [DataWarehouse].[Bronze].[erp_px_cat_G1V2]

    SET @end_time = GETDATE()
    PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds'
    PRINT '>> --------------';

    SET @batch_end_time = GETDATE();
    PRINT '================================================'
    PRINT 'Loading Silver Layer is Completed';
    PRINT '     - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
    PRINT '================================================'

END TRY
    BEGIN CATCH
        PRINT '================================================'
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Messsage' + ERROR_MESSAGE();
        PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
    END CATCH
END
