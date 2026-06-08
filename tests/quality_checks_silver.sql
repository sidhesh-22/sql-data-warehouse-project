/*
================================================================================
Quality Checks
================================================================================
Script Purpose:
  This script performs various quality checks for data consistency, accuracy,
  and standardization across the 'silver' schemas. It includes checks for:
  - Null or duplicate primary keys.
  - Unwanted spaces in the string fields.
  - Data standardization and consistency.
  - Invalid date ranges and orders.
  - Data consistency between related fields.

Usage Notes:
  - Run these checks after loading the Silver Layer. 
  - Investigate and resolve any discrepancies found during the checks.
================================================================================
*/

-- ================================================================================
	-- Checking crm_cust_info table
-- ================================================================================
	--Check for nulls or duplicates in primary key
	
	select cst_id,
	count(*)
	from silver.crm_cust_info
	group by 1
	having count(*) > 1 or cst_id is null

  --- Check for unwanted spaces
	select cst_lastname
	from silver.crm_cust_info
	where cst_lastname != trim(cst_lastname)
	
	--- Data Standardization & Consistency
	select distinct cst_marital_status
	from silver.crm_cust_info
	

-- ================================================================================
-- Checking for crm_prd_info
-- ================================================================================  	
-- Check duplicates--
	select prd_id,count(*)
	from silver.crm_prd_info
	group by 1
	having count(*) > 1 or prd_id is null
	
	-- Check for unwated spaces --
	select prd_nm
	from silver.crm_prd_info
	where prd_nm != trim(prd_nm)
	
	-- Check for nulls or negative numbers
	select prd_cost
	from silver.crm_prd_info
	where prd_cost < 0 or prd_cost is null
	
	-- Data Standardization --
	select distinct prd_line
	from silver.crm_prd_info
	
	-- Check invalid Order Dates -- 
	select * from silver.crm_prd_info
	where prd_end_dt < prd_start_dt
	

-- ================================================================================
	--- Checking for crm_sls_details -----
-- ================================================================================
	--Check for invalid date orders
	select 
	*
	from silver.crm_sales_details
	where sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt
	
	-- Check Data Consistency between Sales, Quantity, and Price --
	
	select sls_sales, sls_quantity, sls_price
	from silver.crm_sales_details
	where sls_sales != sls_quantity * sls_price
	or sls_sales is null or sls_quantity is null or sls_price is null
	or sls_sales < 0 or sls_quantity < 0 or sls_price < 0
	
-- ================================================================================
	-- Checking for erp_cust_az12 ---
-- ================================================================================
	-- Identify out-of-range dates
	select distinct bdate 
	from silver.erp_cust_az12
	where bdate < '1924-01-01' or bdate > now()
	
	--- Data Standardization & Consistency
	select distinct gen
	from silver.erp_cust_az12

-- ================================================================================
--- Checking for erp_loc_a101 ---
-- ================================================================================
	-- Data Standardization & Consistency ----
	
	select distinct cntry
	from silver.erp_loc_a101
	order by cntry

-- ================================================================================
	--- Checking for erp_px.cat_g1v2 ---
-- ================================================================================
	-- Check for unwanted spaces ---
	select * from bronze.erp_px_cat_g1v2
	where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance)
	
	-- Data Standardization and Consistency ---
	select distinct maintenance
	from bronze.erp_px_cat_g1v2
