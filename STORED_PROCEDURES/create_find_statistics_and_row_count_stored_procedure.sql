USE `innodb_profiling`;
DROP procedure IF EXISTS `find_table_statistics_and_row_count`;

DELIMITER $$
USE `innodb_profiling`$$
CREATE DEFINER=`username`@`hostname` PROCEDURE `find_table_statistics_and_row_count`()
BEGIN
/* ------------------------------------------------------------------------ */
-- This procedure will find the row count estimation table statistics for
-- our different tables. Each has been set to collect these statistics using
-- a different sample size. We will also find the actual number of rows.
--
-- Once we have found the table statistics estimations about each individual
-- table, we will insert these into our measurement table.
/* ------------------------------------------------------------------------ */
-- NOTE: All variables need to be declared before any queries occur, or
-- MySQL will throw a syntax error, and the procedure cannot be compiled.
--
-- NOTE: Important! This procedure waits for 1 second between each
-- ANALYZE TABLE call, so this will take a minimum of 3 seconds.
/* ------------------------------------------------------------------------ */
/*    Declare variables for each table's real and estimated row count. */
/* ------------------------------------------------------------------------ */
    DECLARE default_sample_row_count_estimate INT;
    DECLARE default_sample_row_count_real_count INT;

    DECLARE size_10_sample_row_count_estimate INT;
    DECLARE size_10_sample_row_count_real_count INT;

    DECLARE size_100_sample_row_count_estimate INT;
    DECLARE size_100_sample_row_count_real_count INT;

    DECLARE size_1000_sample_row_count_estimate INT;
    DECLARE size_1000_sample_row_count_real_count INT;

    /* ------------------------------------------------------------------------ */
    -- Declare our first and second random variables to insert into the tables,
    -- and set them to individual random values. Note that we multiply this number
    -- by 100 so that it is a random number between 0 and 100, rather than 0 or 1.
    /* ------------------------------------------------------------------------ */
    DECLARE my_first_random_value INT;
    DECLARE my_second_random_value INT;
    SET @my_first_random_value = RAND() * 100;
    SET @my_second_random_value = RAND() * 100;

    -- DEBUG, check the vlaues placed into each variable before continuing.
    -- SELECT @my_first_random_value, @my_second_random_value;

    /* ------------------------------------------------------------------------ */
    -- Insert our first and second random number into each InnoDB table.
    /* ------------------------------------------------------------------------ */
    INSERT INTO my_data_table_default
    (first_stored_value,second_stored_value)
    VALUES(@my_first_random_value,@my_second_random_value);

    INSERT INTO my_data_table_sample_10
    (first_stored_value,second_stored_value)
    VALUES(@my_first_random_value,@my_second_random_value);

    INSERT INTO my_data_table_sample_100
    (first_stored_value,second_stored_value)
    VALUES(@my_first_random_value,@my_second_random_value);

    INSERT INTO my_data_table_sample_1000
    (first_stored_value,second_stored_value)
    VALUES(@my_first_random_value,@my_second_random_value);

    /* ------------------------------------------------------------------------ */
    -- Manually invoke ANALYZE TABLE here, because these tables do not automatically
    -- update their InnoDB persistent table statistics. We will sleep for 1 second
    -- between each call, in order to prevent sync errors.
    /* ------------------------------------------------------------------------ */
    ANALYZE TABLE my_data_table_default;
    DO SLEEP (0.3);
    ANALYZE TABLE my_data_table_sample_10;
    DO SLEEP (0.3);
    ANALYZE TABLE my_data_table_sample_100;
    DO SLEEP (0.3);
    ANALYZE TABLE my_data_table_sample_1000;

    /* ------------------------------------------------------------------------ */
    /* Find the real and estimated row counts using a default size sample of pages */
    /* ------------------------------------------------------------------------ */
    SELECT IFNULL(information_schema.TABLES.TABLE_ROWS,0)
    FROM information_schema.TABLES
    WHERE information_schema.TABLES.TABLE_NAME = 'my_data_table_default'
        AND information_schema.TABLES.TABLE_SCHEMA = 'innodb_profiling'
    LIMIT 1
    INTO @default_sample_row_count_estimate;

    SELECT COUNT(*)
    FROM my_data_table_default
    INTO @default_sample_row_count_real_count;

    /* ------------------------------------------------------------------------ */
    /* Find the real and estimated row counts for a table that samples 10 pages.*/
    /* ------------------------------------------------------------------------ */
    SELECT IFNULL(information_schema.TABLES.TABLE_ROWS,0)
    FROM information_schema.TABLES
    WHERE information_schema.TABLES.TABLE_NAME = 'my_data_table_sample_10'
        AND information_schema.TABLES.TABLE_SCHEMA = 'innodb_profiling'
    LIMIT 1
    INTO @size_10_sample_row_count_estimate;

    SELECT COUNT(*)
    FROM my_data_table_default
    INTO @size_10_sample_row_count_real_count;

    /* ------------------------------------------------------------------------ */
    /* Find the real and estimated row counts for a table that samples 100 pages.*/
    /* ------------------------------------------------------------------------ */
    SELECT IFNULL(information_schema.TABLES.TABLE_ROWS,0)
    FROM information_schema.TABLES
    WHERE information_schema.TABLES.TABLE_NAME = 'my_data_table_sample_100'
        AND information_schema.TABLES.TABLE_SCHEMA = 'innodb_profiling'
    LIMIT 1
    INTO @size_100_sample_row_count_estimate;

    SELECT COUNT(*)
    FROM my_data_table_default
    INTO @size_100_sample_row_count_real_count;

    /* ------------------------------------------------------------------------ */
    /* Find the real and estimated row counts for a table that samples 1000 pages.*/
    /* ------------------------------------------------------------------------ */
    SELECT IFNULL(information_schema.TABLES.TABLE_ROWS,0)
    FROM information_schema.TABLES
    WHERE information_schema.TABLES.TABLE_NAME = 'my_data_table_sample_1000'
        AND information_schema.TABLES.TABLE_SCHEMA = 'innodb_profiling'
    LIMIT 1
    INTO @size_1000_sample_row_count_estimate;

    SELECT COUNT(*)
    FROM my_data_table_default
    INTO @size_1000_sample_row_count_real_count;

    /* ------------------------------------------------------------------------ */
    /* Select our result set, including each table's real and estimated size. */
    /* ------------------------------------------------------------------------ */
    INSERT INTO innodb_profiling.my_measurement_table
    (real_size,default_sample_estimate,sample_10_pages_estimate,
            sample_100_pages_estimate,sample_1000_pages_estimate)
    VALUES(@default_sample_row_count_real_count, @default_sample_row_count_estimate,
            @size_10_sample_row_count_estimate,@size_100_sample_row_count_estimate,
            @size_1000_sample_row_count_estimate);
END$$

DELIMITER ;
