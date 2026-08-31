-- The CROSS APPLY clause allows you to perform an inner join a table with a table-valued function or a correlated subquery.
-- In SQL Server, a table-valued function is a user-defined function that returns multiple rows as a table.
-- Personally, I feel like this is a solid method to make data analysis more incremental.
    -- It is like an INNER JOIN
    
-- CROSS APPLY with a table-valued function:
-- Q: What are the top two most expensive products by category ID?
CREATE OR ALTER FUNCTION GetTopProductsByCategory (@category_id INT)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (2) *
    FROM production.products p
    WHERE p.category_id = @category_id
    ORDER BY list_price DESC, product_name
);
GO -- GO is required because *_FUNCTION statements are batch-level
SELECT
    c.category_name,
    r.product_name,
    r.list_price
FROM
    production.categories c
    CROSS APPLY GetTopProductsByCategory(c.category_id) r -- Table-valued expression here
ORDER BY
    c.category_name,
    r.list_price DESC;

-- CROSS APPLY with a correlated subquery:
-- Q: What are the top two most expensive products for each product category?
SELECT
    c.category_name,
    r.product_name,
    r.list_price
FROM
    production.categories c
    CROSS APPLY (
        SELECT TOP 2 *
        FROM production.products p
        WHERE p.category_id = c.category_id
        ORDER BY list_price DESC, product_name
    ) r
ORDER BY
    c.category_name,
    r.list_price DESC;

-- CROSS APPLY to process JSON data
-- What is the result set for all entries in the products_json table?
-- First, a general result set to show what the data looks like before advanced querying.
Select * from product_json;
-- Now, you can see how the below CROSS APPLY clause will parse the data into more structure.
SELECT
  p.id,
  j.*
FROM
  product_json p
  CROSS APPLY OPENJSON (p.info) WITH -- OPENJASON called
  (
    Name NVARCHAR(100),
    Price DECIMAL(10, 2),
    Category NVARCHAR(100)
  ) AS j;
-- Result: Messy data is reported in a clean manner.

-- CROSS APPLY to remove nested REPLACE() functions:
-- What are the company names without the trailing legal suffix?
-- First, use the REPLACE() function to show how compressed the query syntax is.
SELECT TRIM(REPLACE(REPLACE(REPLACE(name,'Corporation',''), 'Inc.',''),'Pte Ltd','')) company_name
FROM companies;
-- Now, let's make the query syntax more modular by using CROSS APPLY.
SELECT TRIM(r3.name) company_name
FROM companies c
CROSS APPLY (SELECT REPLACE(c.name,'Corporation', '') name) AS r1
CROSS APPLY (SELECT REPLACE(r1.name,'Inc.', '') name) AS r2
CROSS APPLY (SELECT REPLACE(r2.name,'Pte Ltd', '') name) AS r3;
-- RESULT: The CROSS APPLY version removes the suffixes incrementally, one transformation at a time.
