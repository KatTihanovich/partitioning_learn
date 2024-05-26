CREATE OR REPLACE FUNCTION generate_insert_data()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    sale_date DATE;
    new_sale_id INTEGER;
BEGIN
    FOR counter IN 1..1000 LOOP
    sale_date := '2023-05-01'::DATE + (FLOOR(RANDOM() * 365) * INTERVAL '1 day');
    new_sale_id := counter;

        INSERT INTO sales_data(sale_id, sale_date, salesperson_id, region_id, product_id, sale_amount)
        VALUES (
            new_sale_id,
            sale_date,
            1 + FLOOR(RANDOM() * 6), 
            1 + FLOOR(RANDOM() * 10), 
            1 + FLOOR(RANDOM() * 8),  
            40 + FLOOR(RANDOM() * 1000)  
        );
    END LOOP;
END;
$$;

SELECT generate_insert_data();