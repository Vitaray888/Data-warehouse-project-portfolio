/***********************************************************************
---------------------- Silver.erp_cust_az12 ---------------------------
***********************************************************************/

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

/***********************************************************************
----------------------- Silver.erp_Loc_A101 --------------------------
***********************************************************************/

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

  
/***********************************************************************
----------------------- Silver.erp_px_cat_G1V2 --------------------------
***********************************************************************/

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
