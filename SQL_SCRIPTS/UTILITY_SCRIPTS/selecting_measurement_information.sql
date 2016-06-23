/* --------------------------------------------------------------------------- */
/* These queries selects the persistent statistic information about our table */
/* --------------------------------------------------------------------------- */
-- TODO: Join each individual select to create a measurement row.

SELECT information_schema.TABLES.TABLE_ROWS AS estimated_row_count_default
FROM information_schema.TABLES
WHERE information_schema.TABLES.TABLE_NAME = 'my_data_table_default';

SELECT information_schema.TABLES.TABLE_ROWS AS estimated_row_count_sample_10
FROM information_schema.TABLES
WHERE information_schema.TABLES.TABLE_NAME = 'my_data_table_sample_10';

SELECT information_schema.TABLES.TABLE_ROWS AS estimated_row_count_sample_100
FROM information_schema.TABLES
WHERE information_schema.TABLES.TABLE_NAME = 'my_data_table_sample_100';

SELECT information_schema.TABLES.TABLE_ROWS AS estimated_row_count_sample_1000
FROM information_schema.TABLES
WHERE information_schema.TABLES.TABLE_NAME = 'my_data_table_sample_1000';

/* --------------------------------------------------------------------------- */
/* These queries selects the *real* row count for our table */
/* --------------------------------------------------------------------------- */
SELECT COUNT(*) AS real_row_count_default
FROM my_data_table_default;
SELECT COUNT(*) AS real_row_count_sample_10
FROM my_data_table_sample_10;
SELECT COUNT(*) AS real_row_count_sample_100
FROM my_data_table_sample_100;
SELECT COUNT(*) AS real_row_count_sample_1000
FROM my_data_table_sample_1000;
