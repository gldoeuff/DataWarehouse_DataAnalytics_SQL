/*
================================
Create Database and Schemas
================================

Script Purpose:
	This Script creats a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped and recreated. Additionally, the scripts sets up three schemas with the database:
	'bronze', 'silver', 'gold'

	WARNING:
	Running the script will drop entirely the entire 'DataWarehouse' database if it exists.
	All data in the database will be deleted. 

*/


-- Create Database 'DataWarehouse'

USE master;
GO

-- Drop and recreate the 'DataWarehouse' Database
IF EXISTS(SELECT 1 from sys.databases WHERE name='DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' Database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO