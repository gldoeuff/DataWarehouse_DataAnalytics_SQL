/*
====================================
Database exploration
====================================
Objective:
	- explore the overall structure of the tables: list of tables,schemas....
	- explore the columns of the tables
*/

-- tables list of the database

SELECT * FROM INFORMATION_SCHEMA.TABLES


-- list of the tables in  the gold layer view

SELECT * FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA='gold';

-- list of the columns for each table in the gold layer


SELECT 
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE, 
CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='gold' AND TABLE_NAME='dim_customers';


SELECT  
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE, 
CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='gold' AND TABLE_NAME='dim_products';


SELECT  
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE, 
CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='gold' AND TABLE_NAME='fact_sales';
