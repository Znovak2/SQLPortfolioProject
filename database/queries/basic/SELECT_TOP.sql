-- SELECT TOP can be explicit rows or percent of the data

-- Explicit number of rows example
-- List the top 10 most expensive items
SELECT TOP 10 product_name, list_price
FROM production.products
ORDER BY list_price DESC;

-- Percentage of rows example
-- List the top 1 percent most expensive items
SELECT TOP 1 PERCENT product_name, list_price
FROM production.products
ORDER BY list_price DESC;

-- Sometimes there are ties in the data i.e., the third top row might have the same value as the sixth top row.
-- WITH TIES solves this
SELECT TOP 3 WITH TIES product_name, list_price
FROM production.products
ORDER BY list_price DESC;