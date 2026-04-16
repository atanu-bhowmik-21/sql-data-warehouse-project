-- *********** bronze.crm_cust_info ****************

-- CHECK FOR NULLS IN PRIMARY KEY
SELECT 
cst_id,COUNT(*) 
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;

-- TABLE STRUCTURE	
EXEC SP_HELP 'bronze.crm_cust_info';

-- SEE ONE RECORD 
SELECT * 
FROM bronze.crm_cust_info
WHERE cst_id = 29466;


-- CHECK FOR SPACES FOR STRINGS
SELECT
cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- DATA CONSISTENCY
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_material_staus
FROM bronze.crm_cust_info;


-- *********** bronze.crm_prd_info ****************

-- CHECK FOR NULLS IN PRIMARY KEY
SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL;

-- check where end date is less than start date
SELECT * FROM
bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT * FROM
silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- PRICE CONSTRAINT CHECK

SELECT * FROM
bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

SELECT * FROM
silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- *********** bronze.crm_sales_details ****************

-- sales logic check
SELECT * 
FROM silver.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity;

-- date logic check
SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt and sls_order_dt > sls_due_dt;

-- *********** bronze.erp_cust_az12 ****************

-- membership check
select 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
	 ELSE cid
END AS cid,
bdate,
gen
from silver.erp_cust_az12
where CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
	 ELSE cid
END not in (select distinct cst_key from silver.crm_cust_info);

-- future date check
select * 
from bronze.erp_cust_az12
where bdate > GETDATE();

select * 
from silver.erp_cust_az12
where bdate > GETDATE();

select * 
from silver.erp_cust_az12;

-- *********** silver.erp_loc_a101 ****************

select 
REPLACE(cid,'-','') AS cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
	 WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'n/a'
	 ELSE TRIM(cntry)
END AS cntry
from bronze.erp_loc_a101
where REPLACE(cid,'-','') not in (select cst_key from silver.crm_cust_info);

select distinct cntry from bronze.erp_loc_a101;

select distinct cntry from silver.erp_loc_a101;

SELECT * FROM silver.erp_loc_a101;

-- *********** silver.erp_px_cat_g1v2 ****************
SELECT * FROM bronze.erp_px_cat_g1v2;

SELECT * FROM silver.erp_px_cat_g1v2;




