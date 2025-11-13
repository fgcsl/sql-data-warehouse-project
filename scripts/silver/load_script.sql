INSERT INTO silver.crm_prd_info (
prd_id,
cat_id,
prd_key,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)

SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key,1,5), '-','_' )as cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) as prd_key,
ISNULL (prd_cost,0) AS prd_cost,
CASE WHEN UPPER(TRIM(prd_line))= 'M' THEN 'Mountain'
	 WHEN UPPER(TRIM(prd_line))= 'R' THEN 'Road'
	 WHEN UPPER(TRIM(prd_line))= 'S' THEN 'Oher Sales'
	 WHEN UPPER(TRIM(prd_line))= 'T' THEN 'Touring' 
ELSE 'n/a'
END AS prd_line,
CAST (prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt_test
FROM bronze.crm_prd_info;




/* check */
select * from bronze.crm_sales_details where 
sls_price != sls_sales * sls_quantity or
sls_sales is NULL or sls_quantity is NULL or sls_price is NULL 
or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0;

/* execution check */

SELECT 
sls_ord_num, 
sls_prd_key, 
sls_cust_id, 
CASE WHEN sls_order_dt = 0 or LEN(sls_order_dt) !=8 THEN NULL
ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END AS sls_order_dt,

CASE WHEN sls_ship_dt = 0 or LEN(sls_ship_dt) !=8 THEN NULL
ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 or LEN(sls_due_dt) !=8 THEN NULL
ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END AS sls_due_dt,
sls_sales, 
sls_quantity, 
sls_price
from bronze.crm_sales_details ;
