/* 
========================================================================
DDL Script: Create Gold Layer Views
========================================================================

Script Purpose:
    This script creates analytical views for the Gold layer of the data warehouse.

    The Gold layer represents the final dimension and fact structures
    following a Star Schema design.

    Each view transforms and combines data from the Silver layer
    to produce clean, enriched, and business-ready datasets.

Usage:
    - These views can be queried directly for analytics and reporting.
    - Intended for BI consumption and analytical workloads.
========================================================================
*/

-----------------------------------------------------------------------
-- Dimension: Customers (Gold Layer)
-----------------------------------------------------------------------
-- Notes:
-- - Resolves integration issues between CRM and ERP sources
-- - Standardizes naming (snake_case, English, no reserved words)
-- - Columns ordered in logical business sequence
-- - Surrogate key generated via ROW_NUMBER (non-persistent)
-- - Object Type: View (virtual table)
-----------------------------------------------------------------------

IF OBJECT_ID('Gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW Gold.dim_customers;
GO

CREATE VIEW Gold.dim_customers AS

SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.Cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE 
        WHEN ci.cst_gnder <> 'n/a' THEN ci.cst_gnder
        ELSE COALESCE(ca.Gen, 'n/a')
    END AS gender,
    ca.Bdate AS birthdate,
    ci.cst_create_date AS created_date
FROM Silver.crm_cust_info ci
LEFT JOIN Silver.erp_cust_az12 ca 
    ON ci.cst_key = ca.Cid
LEFT JOIN Silver.erp_Loc_A101 la 
    ON ci.cst_key = la.Cid;
GO


-----------------------------------------------------------------------
-- Dimension: Products (Gold Layer)
-----------------------------------------------------------------------
-- Notes:
-- - Excludes historical product records
-- - Standardized naming and column ordering
-- - Surrogate key generated via ROW_NUMBER (non-persistent)
-- - Object Type: View (virtual table)
-----------------------------------------------------------------------

IF OBJECT_ID('Gold.dim_products', 'V') IS NOT NULL
    DROP VIEW Gold.dim_products;
GO

CREATE VIEW Gold.dim_products AS

SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM Silver.crm_prd_info pn
LEFT JOIN Silver.erp_px_cat_G1V2 pc 
    ON pn.cat_id = pc.ID
WHERE pn.prd_end_dt IS NULL;
GO


-----------------------------------------------------------------------
-- Fact: Sales (Gold Layer)
-----------------------------------------------------------------------
-- Notes:
-- - Uses surrogate keys from dimension views
-- - Fact grain: one record per sales order line
-- - Designed for analytical aggregation
-- - Object Type: View (virtual table)
-----------------------------------------------------------------------

IF OBJECT_ID('Gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW Gold.fact_sales;
GO

CREATE VIEW Gold.fact_sales AS

SELECT
    sd.sls_ord_nums AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM Silver.crm_sales_details sd
LEFT JOIN Gold.dim_products pr 
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN Gold.dim_customers cu 
    ON sd.sls_cust_id = cu.customer_id;
GO
