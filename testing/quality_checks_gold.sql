/* 
=========================================================
QUALITY CHECKS – GOLD LAYER
Purpose:
    Validate integrity, uniqueness, and business rules
    for Gold dimension and fact views.
=========================================================
*/

---------------------------------------------------------
-- 1. Ensure customer surrogate key is unique
-- Expected result: 0 rows
---------------------------------------------------------

SELECT customer_key, COUNT(*) 
FROM Gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


---------------------------------------------------------
-- 2. Ensure business key (customer_id) is unique
-- Expected result: 0 rows
---------------------------------------------------------

SELECT customer_id, COUNT(*) 
FROM Gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


---------------------------------------------------------
-- 3. Validate allowed gender domain
-- Expected values: 'M', 'F', 'n/a'
---------------------------------------------------------

SELECT DISTINCT gender
FROM Gold.dim_customers
WHERE gender NOT IN ('M', 'F', 'n/a');


---------------------------------------------------------
-- 4. Ensure product surrogate key is unique
-- Expected result: 0 rows
---------------------------------------------------------

SELECT product_key, COUNT(*) 
FROM Gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


---------------------------------------------------------
-- 5. Fact table: Ensure no orphaned customer references
-- Expected result: 0 rows
---------------------------------------------------------

SELECT *
FROM Gold.fact_sales fs
LEFT JOIN Gold.dim_customers dc
    ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;


---------------------------------------------------------
-- 6. Fact table: Ensure no orphaned product references
-- Expected result: 0 rows
---------------------------------------------------------

SELECT *
FROM Gold.fact_sales fs
LEFT JOIN Gold.dim_products dp
    ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;


---------------------------------------------------------
-- 7. Ensure sales metrics are non-negative
-- Expected result: 0 rows
---------------------------------------------------------

SELECT *
FROM Gold.fact_sales
WHERE sales_amount < 0
   OR quantity < 0;
