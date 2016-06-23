/* --------------------------------------------------------------------------- */
-- Written by Kevin Martin.
/* --------------------------------------------------------------------------- */
-- Inno DB will estimate the size of a table. How does this
-- differ from the real size as the number of rows increases?
-- We will examine how different configurations of stats_sample_pages
-- affects this.
--
-- While there are a number of other ways to tune query performance, the
-- purpose of this exercise is to observe the effect that sample size has
-- on InnoDB table statistics. These statistics are used for estimation.
/* --------------------------------------------------------------------------- */
/* This script will create a new schema for testing InnoDB's statistics.
*  Here, we prepare for the procedure, before beginning our loop. If a schema
*  does not exist yet when we start the program, create a new schema. */
/* --------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------- */
CREATE SCHEMA IF NOT EXISTS innodb_profiling;
USE innodb_profiling;

/* --------------------------------------------------------------------------- */
/* If table does not already exist, we should create our table. Note that we
-- use specific table options regarding InnoDB's statistics. See below for more.
-- By default, STATS_PERSISTENT and STATS_AUTO_RECALC are enabled.
-- We will disable STATS_AUTO_RECALC so that we can manually control when
-- the tables recalculate their statistics. According to the documentation,
-- sometimes these updates might not happen immediately. */
/* --------------------------------------------------------------------------- */

-- This table will use the default number of page samples to estimate table size.
-- NOTE: If tables already exist, they are left in place. Check that these are
-- designed correctly if you use an existing table space (see DEBUG statements below).
CREATE TABLE IF NOT EXISTS my_data_table_default
(
	id INT AUTO_INCREMENT NOT NULL,
	first_stored_value INT NOT NULL,
    second_stored_value INT NOT NULL,
    CONSTRAINT my_data_table_pk PRIMARY KEY (id)
)
ENGINE=InnoDB,
STATS_PERSISTENT=1,
STATS_AUTO_RECALC=0;

-- The following tables will samples 10, 100, and 1000 pages (respectively)
-- when estimating an InnoDB table's size. Notice we have
-- disabled automatic recalculation. Call ANALYZE TABLE manually.
CREATE TABLE IF NOT EXISTS my_data_table_sample_10
(
	id INT AUTO_INCREMENT NOT NULL,
	first_stored_value INT NOT NULL,
    second_stored_value INT NOT NULL,
    CONSTRAINT my_data_table_pk PRIMARY KEY (id)
)
ENGINE=InnoDB,
STATS_PERSISTENT=1,
STATS_AUTO_RECALC=0,
STATS_SAMPLE_PAGES=10;

CREATE TABLE IF NOT EXISTS my_data_table_sample_100
(
	id INT AUTO_INCREMENT NOT NULL,
	first_stored_value INT NOT NULL,
    second_stored_value INT NOT NULL,
    CONSTRAINT my_data_table_pk PRIMARY KEY (id)
)
ENGINE=InnoDB,
STATS_PERSISTENT=1,
STATS_AUTO_RECALC=0,
STATS_SAMPLE_PAGES=100;

CREATE TABLE IF NOT EXISTS my_data_table_sample_1000
(
	id INT AUTO_INCREMENT NOT NULL,
	first_stored_value INT NOT NULL,
    second_stored_value INT NOT NULL,
    CONSTRAINT my_data_table_pk PRIMARY KEY (id)
)
ENGINE=InnoDB,
STATS_PERSISTENT=1,
STATS_AUTO_RECALC=0,
STATS_SAMPLE_PAGES=1000;

CREATE TABLE IF NOT EXISTS my_measurement_table
(
    real_size INT,
    default_sample_estimate INT,
    sample_10_pages_estimate INT,
    sample_100_pages_estimate INT,
    sample_1000_pages_estimate INT
);
