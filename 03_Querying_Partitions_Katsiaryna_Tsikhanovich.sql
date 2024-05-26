SELECT *
FROM sales_data
WHERE sale_date BETWEEN '2024-03-01' AND '2024-03-31';

SELECT 
    DATE_TRUNC('month', sale_date) AS month,
    SUM(sale_amount) AS total_sales
FROM 
    sales_data
GROUP BY 
    month
ORDER BY 
    month;
	
SELECT 
    salesperson_id,
    SUM(sale_amount) AS total_sales
FROM 
    sales_data
WHERE 
    region_id = 4
GROUP BY 
    salesperson_id
ORDER BY 
    total_sales DESC
LIMIT 3;