/* Written by Kevin Martin.
 *
 * This script is used for making backup tables to store measurement
 * information. This is a helpful script if you are going to clear the
 * tablespace, and would like to save a backup in case you want to revert.
*/

USE innodb_profiling;

CREATE TABLE backup_table_01 LIKE my_data_table_default;
SHOW TABLES;

INSERT INTO backup_table_01
SELECT * FROM my_data_table_default;
