USE `innodb_profiling`;
DROP procedure IF EXISTS `perform_innodb_profiling_procedure`;

DELIMITER $$
USE `innodb_profiling`$$
CREATE DEFINER=`username`@`hostname` PROCEDURE `perform_innodb_profiling_procedure`()
BEGIN
/*    This stored procedure will call and execute the find_table_statistics_and_row_count
*    stored procedure in the innodb_profiling database. The number of times this is performed
*    is decided by the default value of max_number_of_iterations. Note that this procedure
*    does not take any input parameters, the number of times we will perform the operation is
*    set by this hardcoded value. Check the measurement table afterwards to see the results.
*
*    NOTE: The find_table_statistics_and_row_count procedure includes 3 calls to SLEEP for
*    1 second. In total, we are including 4 seconds of sleep time in this process in order
*    to prevent a sync error. For time estimation purposes, we can round up and assume each
*    iteration in this loop will take about 5 seconds.
*
*    Performing 100 loops will take about 8-9 minutes.
*
*    Written by Kevin Martin.
*/

    /*    Declare the loop counter and the maximum counter value.    */
    DECLARE current_iteration INT UNSIGNED DEFAULT 0;
    DECLARE max_number_of_iterations INT UNSIGNED DEFAULT 5000;

    /*    This is the for loop, where we will call the stored procedure    */
    WHILE current_iteration < max_number_of_iterations DO
        CALL `innodb_profiling`.`find_table_statistics_and_row_count`();
        DO SLEEP (0.1);
        SET current_iteration = current_iteration + 1;
        SELECT current_iteration, max_number_of_iterations,
            (current_iteration / max_number_of_iterations) * 100 AS 'percent_complete';
    END WHILE;
END$$

DELIMITER ;
