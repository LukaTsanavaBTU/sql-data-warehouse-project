/*

********************************
Create Database and Schemas
********************************

Script Purpose:
	Create a new database named 'DataWarehouse' after checking if it already exists.
	If the database exists, delete it and create it again.
	Set up three schemas called: 'bronze', 'silver' and 'gold'.

WARNING:
	Running this script will drop the entire 'DataWarehouse' database if it exists.
	All data will be permanently deleted. Proceed with caution and ensure you
	have proper backups before running this script.

*/

USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
