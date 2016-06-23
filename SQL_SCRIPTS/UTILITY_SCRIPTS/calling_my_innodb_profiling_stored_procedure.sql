-- NOTE: These are not normal single quotes. Use the tick (same as the ~ key).
-- CALL `innodb_profiling`.`find_table_statistics_and_row_count`();

CALL `innodb_profiling`.`perform_innodb_profiling_procedure`();

-- Use this query to view the contents of the measurement table.
-- SELECT * FROM innodb_profiling.my_measurement_table;
