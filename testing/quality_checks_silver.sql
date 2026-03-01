/*
===============================================================================
QUALITY CHECKS – SILVER LAYER
===============================================================================
Purpose:
    Enforce data integrity, standardization, and business rules
    after Silver transformations.

Validation Principle:
    Each query must return 0 rows.
    Any returned rows indicate a data quality issue.
===============================================================================
*/

-----------------------------------------------------------------------
-- 1. Primary Key Integrity – crm_cust_info
-----------------------------------------------------------------------

-- NULL Check
SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL;

-- Duplicate Check
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;


-----------------------------------------------------------------------
-- 2. String Standardization – crm_cust_info
-----------------------------------------------------------------------

SELECT *
FROM silver.crm_cust_info
WHERE cst_key IS NOT NULL
  AND cst_key <> LTRIM(RTRIM(cst_key));


-----------------------------------------------------------------------
-- 3. Product Cost Validation
-----------------------------------------------------------------------

SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL
   OR prd_cost < 0;


-----------------------------------------------------------------------
-- 4. Product Date Validation
-----------------------------------------------------------------------

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt IS NOT NULL
  AND prd_end_dt < prd_start_dt;


-----------------------------------------------------------------------
-- 5. Sales Date Logic
-----------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


-----------------------------------------------------------------------
-- 6. Sales Amount Consistency (Precision Safe)
-----------------------------------------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE ABS(sls_sales - (sls_quantity * sls_price)) > 0.01;


-----------------------------------------------------------------------
-- 7. Birthdate Validation
-----------------------------------------------------------------------

SELECT *
FROM silver.erp_cust_az12
WHERE bdate < DATEADD(YEAR, -120, GETDATE())
   OR bdate > GETDATE();
