--Define a maintenance task to drop partitions older than 12 months and create new partitions for the next month.
-- Procedure to manage monthly partition maintenance
CREATE OR REPLACE PROCEDURE manage_partitions()
LANGUAGE plpgsql
AS $$
DECLARE
    current_date DATE := CURRENT_DATE;
    last_year_date DATE := current_date - INTERVAL '1 year';
    partition_date_to_remove DATE;
    next_month_start DATE := DATE_TRUNC('month', current_date) + INTERVAL '1 month';
    next_month_end DATE := next_month_start + INTERVAL '1 month';
    month_start DATE;
    month_end DATE;
    partition_date_to_add DATE;
    partition_name VARCHAR;
    next_month_name VARCHAR;
BEGIN
    FOR counter IN 0..11 LOOP
        partition_date_to_remove := last_year_date - (INTERVAL '1 month' * counter);
        partition_name := 'sales_data_' || TO_CHAR(partition_date_to_remove, 'YYYY_MM');
        IF TO_REGCLASS(partition_name) IS NOT NULL THEN
            EXECUTE FORMAT('DROP TABLE %I', partition_name);
            RAISE NOTICE 'Dropped partition: %', partition_name;
        ELSE
            RAISE NOTICE 'Partition % does not exist, skipping drop.', partition_name;
        END IF;

        partition_date_to_add := next_month_start - (INTERVAL '1 month' * counter);
        next_month_name := 'sales_data_' || TO_CHAR(partition_date_to_add, 'YYYY_MM');
        month_start := DATE_TRUNC('month', partition_date_to_add);
        month_end := month_start + INTERVAL '1 month';
        IF TO_REGCLASS(next_month_name) IS NULL THEN
            EXECUTE FORMAT('CREATE TABLE %I PARTITION OF sales_data FOR VALUES FROM (%L) TO (%L)', 
                           next_month_name, month_start, month_end);
            RAISE NOTICE 'Created partition: %', next_month_name;
        ELSE
            RAISE NOTICE 'Partition % already exists, skipping creation.', next_month_name;
        END IF;
    END LOOP;
END;
$$;

CALL manage_partitions();
