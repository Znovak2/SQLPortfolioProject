-- Enhanced with AI assistance to improve repository reproducibility.

/*
--------------------------------------------------------------------
BikeStores Cleanup Utility
--------------------------------------------------------------------
Drops project tables and schemas in dependency-safe order.

WARNING: This script is destructive and removes all data stored in
the listed objects.
--------------------------------------------------------------------
*/

------------------------------------------------------------
-- DROP TABLES
------------------------------------------------------------

-- PM
DROP TABLE IF EXISTS pm.members;
DROP TABLE IF EXISTS pm.projects;

-- HR
DROP TABLE IF EXISTS hr.candidates;
DROP TABLE IF EXISTS hr.employees;

-- Sales / Production
DROP TABLE IF EXISTS sales.order_items;
DROP TABLE IF EXISTS production.stocks;
DROP TABLE IF EXISTS sales.orders;
DROP TABLE IF EXISTS sales.staffs;
DROP TABLE IF EXISTS sales.customers;
DROP TABLE IF EXISTS sales.stores;
DROP TABLE IF EXISTS production.products;
DROP TABLE IF EXISTS production.categories;
DROP TABLE IF EXISTS production.brands;

------------------------------------------------------------
-- DROP SCHEMAS
------------------------------------------------------------

IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'pm')
    EXEC('DROP SCHEMA pm');
GO

IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'hr')
    EXEC('DROP SCHEMA hr');
GO

IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'sales')
    EXEC('DROP SCHEMA sales');
GO

IF EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'production')
    EXEC('DROP SCHEMA production');
GO
