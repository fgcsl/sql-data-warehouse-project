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
