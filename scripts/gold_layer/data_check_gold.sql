SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen,'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci 
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2


select * from gold.dim_products;

select *
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON REPLACE(sd.sls_prd_key,'-','_') = pr.product_number

SELECT * 
FROM  gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON C.customer_key  = f.customer_key
WHERE f.customer_key IS NULL


SELECT * 
FROM  gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key  = f.product_key
WHERE f.product_key IS NULL
