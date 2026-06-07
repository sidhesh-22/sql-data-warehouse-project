/*
======================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
======================================================================================
Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
    -Truncates the bronze tables before loading the data.
    - Uses the COPY command to load data from CSV files to bronze tables.

Parameters:
None.
This stored procedure neither accepts parameters nor returns values.

Usage Example:
  call load_bronze()

======================================================================================
*/


create or replace procedure bronze.load_bronze ()
LANGUAGE plpgsql
AS $$
declare v_start timestamp;
declare v_proc_start timestamp;
begin
	v_proc_start:= clock_timestamp();
	raise info '================================';
	raise info 'Loading Bronze Layer';
	raise info '================================';

	raise info '================================';
	raise info 'Loading CRM Tables';
	raise info '================================';

	v_start := clock_timestamp();
	raise info '>> Truncating Table: bronze.crm_cust_info';
	truncate table bronze.crm_cust_info;

	raise info '>> Inserting data into: bronze.crm_cust_info';
	COPY bronze.crm_cust_info
	FROM '/Users/sidheshbhambid/Documents/Data with Bara SQL/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);

	raise info 'Load duration for bronze.crm_cust_info: %',
        clock_timestamp() - v_start;
		

	v_start := clock_timestamp();
	raise info '>> Truncating Table: bronze.crm_prd_info';
	truncate table bronze.crm_prd_info;

	raise info '>> Inserting data into: bronze.crm_prd_info';
	COPY bronze.crm_prd_info
	FROM '/Users/sidheshbhambid/Documents/Data with Bara SQL/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	
	raise info 'Load duration for bronze.crm_prd_info: %',
        clock_timestamp() - v_start;
		

	v_start := clock_timestamp();
	raise info '>> Truncating Table: bronze.crm_sales_details';
	truncate table bronze.crm_sales_details;

	raise info '>> Inserting data into: bronze.crm_sales_details';
	COPY bronze.crm_sales_details
	FROM '/Users/sidheshbhambid/Documents/Data with Bara SQL/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	raise info 'Load duration for bronze.crm_sales_details: %',
        clock_timestamp() - v_start;

		
	raise info '================================';
	raise info 'Loading ERP Tables';
	raise info '================================';

	v_start := clock_timestamp();
	raise info '>> Truncating Table: bronze.erp_cust_az12';
	truncate table bronze.erp_cust_az12;

	raise info '>> Inserting data into: bronze.erp_cust_az12';
	COPY bronze.erp_cust_az12
	FROM '/Users/sidheshbhambid/Documents/Data with Bara SQL/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	raise info 'Load duration for bronze.erp_cust_az12: %',
        clock_timestamp() - v_start;
		
		
	v_start := clock_timestamp();
	raise info '>> Truncating Table: bronze.erp_loc_a101';
	truncate table bronze.erp_loc_a101;

	raise info '>> Inserting data into: bronze.erp_loc_a101';
	COPY bronze.erp_loc_a101
	FROM '/Users/sidheshbhambid/Documents/Data with Bara SQL/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	raise info 'Load duration for bronze.erp_loc_a101: %',
        clock_timestamp() - v_start;
		
		
	v_start := clock_timestamp();
	raise info '>> Truncating Table: bronze.erp_px_cat_g1v2';
	truncate table bronze.erp_px_cat_g1v2;

	raise info '>> Inserting data into: bronze.erp_px_cat_g1v2';
	COPY bronze.erp_px_cat_g1v2
	FROM '/Users/sidheshbhambid/Documents/Data with Bara SQL/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
	WITH (
	    FORMAT csv,
	    HEADER true
	);
	raise info 'Load duration for bronze.erp_px_cat_g1v2: %',
        clock_timestamp() - v_start;

	raise info 'Loading Bronze Layer is Completed';
	raise info 'Total Load Duration: %', clock_timestamp() - v_proc_start;
		
end;
$$;
