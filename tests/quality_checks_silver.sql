/*

********************************
Quality Checks
********************************

	Script Purpose:
		Perform various quality checks for data consistency, accuracy and standardization
      	across the 'silver' schema. Includes checks for:
     	- Null or duplicate primary keys.
      	- Unwanted spaces in string fields.
     	- Data standardization and consistency.
     	- Invalid date ranges and orders.
     	- Data consistency between related fields.

	Usage Notes:
		- Run these checks after data loading Silver Layer.
		- Investigate and resolve any discrepencies found during checks.
*/


/*

CHECKING QUALITY FOR erp_px_cat_g1v2
*****************************************************

*/


-- Check for inconsistent ids
SELECT
	id
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info);


-- Check for extra spaces
SELECT
	cat
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);


SELECT
	subcat
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);


SELECT
	maintenance
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance);


-- Check for data standardization and consistency issues
SELECT DISTINCT
	cat
FROM bronze.erp_px_cat_g1v2;


SELECT DISTINCT
	subcat
FROM bronze.erp_px_cat_g1v2;


SELECT DISTINCT
	maintenance
FROM bronze.erp_px_cat_g1v2;


/*

CHECKING QUALITY FOR erp_loc_a101
*****************************************************

*/


-- Check for inconsistent ids
SELECT
	REPLACE(cid, '-', '') AS cid
FROM bronze.erp_loc_a101
WHERE REPLACE(cid, '-', '') NOT IN (SELECT cst_key FROM silver.crm_cust_info);


-- Check for data standardization and consistency issues
SELECT DISTINCT
	cntry
FROM bronze.erp_loc_a101;


/*

CHECKING QUALITY FOR erp_cust_az12
*****************************************************

*/


-- Check for inconsistent ids
SELECT 
	cid
FROM silver.erp_cust_az12
WHERE cid NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);


-- Check for out of range dates
SELECT
	bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
	OR bdate > GETDATE();

-- Check for data standardization and consistency issues
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12;


/*

CHECKING QUALITY FOR crm_sales_details
*****************************************************

*/


-- Check for invalid dates
SELECT
	sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
	OR LEN(sls_order_dt) != 8 
	OR sls_order_dt > 20500101
	OR sls_order_dt < 19000101;


-- Check if order date is earlier than shipping or due dates
SELECT
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt >  sls_ship_dt 
	OR sls_order_dt > sls_due_dt;


-- Check validity of sales columns
SELECT
	sls_sales,
	sls_quantity,
	sls_price,
	CASE 
		WHEN sls_price IS NULL OR sls_price <= 0
			THEN NULLIF(sls_sales, 0) / sls_quantity
		ELSE sls_price
	END AS sls_price_new,
	CASE 
		WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales_new
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
	OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
	OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


/*

CHECKING QUALITY FOR crm_prd_info
*****************************************************

*/


-- Check for duplicate or null IDs
SELECT	
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- Check for extra spaces in customer names
SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- Check for nulls or negative numbers
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL;

-- Check for value consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for invalid date orders
SELECT 
	prd_id,
	prd_start_dt, 
	prd_end_dt
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;


/*

CHECKING QUALITY FOR crm_cust_info
*****************************************************

*/


-- Check for duplicate or null IDs
SELECT	
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check for extra spaces in customer names
SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);


-- Check for value consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;
