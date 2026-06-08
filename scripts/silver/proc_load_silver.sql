/*
=================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
=================================================================================
Script Purpose:
  This stored procedure performs the ETL (Extract, Transform, Load) process to
populate the 'silver' schema tables from the 'bronze' schema.
Actions Performed:
  - Truncates Silver Tables.
  - Inserts transformed and cleaned data from Bronze into Silver tables.

Parameters:
None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
call silver.load_silver()
=================================================================================
*/

create or replace procedure silver.load_silver()
language plpgsql
AS $$ 
declare v_start timestamp;
declare v_proc_start timestamp;
begin

	v_proc_start:= clock_timestamp();
	raise info '================================';
	raise info 'Loading Silver Layer';
	raise info '================================';

	raise info '================================';
	raise info 'Loading CRM Tables';
	raise info '================================';

	v_start := clock_timestamp();
	raise info '>> Truncating Table: silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;
	
	raise info '>> Inserting Data Into: silver.crm_cust_info';
	INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, 
				cst_marital_status, cst_gndr,cst_create_date)
	SELECT cst_id, cst_key, TRIM(cst_firstname) AS cst_firstname, TRIM(cst_lastname) AS cst_lastname,
	CASE 
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
		END AS cst_marital_status, -- Normalize marital status values to readable format
	CASE 
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		ELSE 'n/a'
		END AS cst_gndr, -- Normalize gender values to readable format
		cst_create_date
	FROM ( SELECT *,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
			) t
		WHERE flag_last = 1;
		
		raise info 'Load duration for silver.crm_cust_info: %',
        clock_timestamp() - v_start;
		

		v_start := clock_timestamp();
	
	raise info '>> Truncating Table: silver.crm_prd_info';
	truncate table silver.crm_prd_info;
	raise info '>> Inserting Data Into: silver.crm_prd_info';
	
	insert into silver.crm_prd_info (prd_id,cat_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
	select 
		prd_id,
		replace(substring(prd_key,1,5),'-','_') as cat_id, -- Extract category ID
		substring(prd_key,7,length(prd_key)) as prd_key,  -- Extract prodcut key
		prd_nm,
		coalesce(prd_cost,0) as prd_cost,
		case upper(trim(prd_line))
			when 'M' then 'Mountain'
			when 'R' then 'Road'
			when 'S' then 'Other Sales'
			when 'T' then 'Touring'
			else 'n/a' end as prd_line, -- Map product line codes to descriptive values
		cast(prd_start_dt as date) as prd_start_dt,
		CAST(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt) - 1 
		AS DATE) as prd_end_dt -- Calculate end date as one day before the next start date
	from bronze.crm_prd_info;
	raise info 'Load duration for silver.crm_prd_info: %',
        clock_timestamp() - v_start;
		

		v_start := clock_timestamp();
	
	raise info '>> Truncating Table: silver.crm_sales_details';
	truncate table silver.crm_sales_details;
	raise info '>> Inserting Data Into: silver.crm_sales_details';
	
	insert into silver.crm_sales_details(
		sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt,
		sls_sales, sls_quantity, sls_price)
	select
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		case 
			when sls_order_dt = 0 or length(cast(sls_order_dt as varchar)) != 8 then null
			else cast(cast(sls_order_dt as varchar) as date) end as sls_order_dt,
		case 
			when sls_ship_dt = 0 or length(cast(sls_ship_dt as varchar)) != 8 then null
			else cast(cast(sls_ship_dt as varchar) as date) end as sls_ship_dt,
		case 
			when sls_due_dt = 0 or length(cast(sls_due_dt as varchar)) != 8 then null
			else cast(cast(sls_due_dt as varchar) as date) end as sls_due_dt,
		case 
			when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price)
			then sls_quantity * abs(sls_price)
			else sls_sales end as sls_sales,
		sls_quantity,
		case 
			when sls_price is null or sls_price <= 0
			then sls_sales / nullif(sls_quantity, 0)
			else sls_price end as sls_price
		
	from bronze.crm_sales_details;
	
	raise info 'Load duration for silver.crm_sales_details: %',
        clock_timestamp() - v_start;

		
	raise info '================================';
	raise info 'Loading ERP Tables';
	raise info '================================';

	v_start := clock_timestamp();	
	
	raise info '>> Truncating Table: silver.erp_cust_az12';
	truncate table silver.erp_cust_az12;
	raise info '>> Inserting Data Into: silver.erp_cust_az12';
	
	insert into silver.erp_cust_az12(cid, bdate, gen)
	select  
		case when cid like 'NAS%' then substring(cid, 4, length(cid)) -- Remove 'NAS' prefix if present
		else cid end as cid,
		case when bdate > now() then null -- set future birtdates to NULL
		else bdate end as bdate,
		case when upper(trim(gen)) in ('F', 'FEMALE') then 'Female'
			 when upper(trim(gen)) in ('M', 'MALE') then 'Male'
			 else 'n/a' end as gen -- Standardize gender vales and handle unknown cases
	from bronze.erp_cust_az12;
	raise info 'Load duration for silver.erp_cust_az12: %',
        clock_timestamp() - v_start;
		
		
		v_start := clock_timestamp();	
	
	raise info '>> Truncating Table: silver.erp_loc_a101';
	truncate table silver.erp_loc_a101;
	raise info '>> Inserting Data Into: silver.erp_loc_a101';
	
	insert into silver.erp_loc_a101 (cid, cntry)
	select 
		replace(cid, '-','') as cid, 
		case when trim(cntry) = 'DE'  then 'Germany'
			 when trim(cntry) in ('US', 'USA') then 'United States'
			 when trim(cntry) = '' or cntry is null then 'n/a'
			 else trim(cntry)  end as cntry -- Normalize and handle missing or blank country codes
	from bronze.erp_loc_a101;
	raise info 'Load duration for silver.erp_loc_a101: %',
        clock_timestamp() - v_start;
		
		
		v_start := clock_timestamp();	
	
	raise info '>> Truncating Table: silver.erp_px_cat_g1v2';
	truncate table silver.erp_px_cat_g1v2;
	raise info '>> Inserting Data Into: silver.erp_px_cat_g1v2';
	
	insert into silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
	select 
		id, cat, subcat, maintenance
		from bronze.erp_px_cat_g1v2;
		
	raise info 'Load duration for silver.erp_px_cat_g1v2: %',
        clock_timestamp() - v_start;

	raise info 'Loading Silver Layer is Completed';
	raise info 'Total Load Duration: %', clock_timestamp() - v_proc_start;
	
end;
$$;
