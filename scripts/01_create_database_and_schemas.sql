/*********************************************************************
 * Script: 01_initialize_datawarehouse.sql
 * Purpose: Create the DataWarehouse database and establish Bronze, Silver, and Gold schemas
 * Author: Crystal (Vitaray888)
 * Date: 2026-02-15
 * Notes: 
 *   - Run this script on a SQL Server instance
 *   - Ensure the DataWarehouse database does not already exist, or uncomment the CREATE DATABASE line
 *   - Script sets up three schemas in 'DataWarehouse'. Schemas: Bronze, Silver, Gold.
 *   - This sets up the foundational layers for the Medallion Architecture
 *********************************************************************/

-- Switch to master database
USE master;
GO

-- Create DataWarehouse database if it doesn't exist
-- Uncomment the next line if database needs to be created
-- CREATE DATABASE DataWarehouse;
-- GO

-- Switch to DataWarehouse
USE DataWarehouse;
GO

-- Create Bronze layer schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Bronze')
    EXEC('CREATE SCHEMA Bronze;');
GO

-- Create Silver layer schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Silver')
    EXEC('CREATE SCHEMA Silver;');
GO

-- Create Gold layer schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Gold')
    EXEC('CREATE SCHEMA Gold;');
GO
