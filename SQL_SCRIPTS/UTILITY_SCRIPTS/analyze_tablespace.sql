/* Select our profiling database to work with. */
USE innodb_profiling;

/* Display table's status before continuing onward. */
SHOW TABLE STATUS;

/* Delete data from our data tables. */
ANALYZE TABLE my_data_table_default;
ANALYZE TABLE my_data_table_sample_10;
ANALYZE TABLE my_data_table_sample_100;
ANALYZE TABLE my_data_table_sample_1000;

/* Delete data from our measurement table. */
ANALYZE TABLE innodb_profiling.my_measurement_table;

-- Other calls useful for testing
-- SELECT COUNT(*) FROM my_data_table_default;
-- DESCRIBE my_measurement_table;