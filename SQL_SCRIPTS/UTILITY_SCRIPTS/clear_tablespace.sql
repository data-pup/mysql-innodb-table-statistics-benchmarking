/* Written by Kevin Martin.
 * NOTE: This script will clear *all* rows from our innodb_profiling schema.
 * This should ONLY be used when testing early calls to the profiling
 * procedure, to make sure that the process is running correctly.
 *
 * Do NOT run this unless you have backed up your data, and are *sure* that
  * you are ready to delete the information from the tables.
*/

/* Select our profiling database to work with. */
-- USE innodb_profiling;

/* Display table's status before continuing onward. */
-- SHOW TABLE STATUS;

/* Delete data from our data tables. */
-- DELETE FROM my_data_table_default;
-- DELETE FROM my_data_table_sample_10;
-- DELETE FROM my_data_table_sample_100;
-- DELETE FROM my_data_table_sample_1000;

/* Delete data from our measurement table. */
-- DELETE FROM innodb_profiling.my_measurement_table;

-- Other calls useful for testing
-- SELECT COUNT(*) FROM my_data_table_default;
