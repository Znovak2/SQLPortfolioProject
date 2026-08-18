-- ORDER BY defaults to ASC (ascending) order, but you can specify DESC (descending) order if needed
-- SQL Server treats NULL as the lowest value

-- What is the least expensive product?
SELECT *
FROM production.products
ORDER BY list_price;

-- Use Keyword Arguements for additional insight
-- What is the most expensive product?
SELECT *
FROM production.products
ORDER BY list_price DESC;

-- ASC/DESC can work for text values as well as numeric values
-- What is the first product in alphabetical order? ASC = A-Z
SELECT *
FROM production.products
ORDER BY product_name ASC;

-- ORDER BY can stack sorts for very granular analysis
-- What is the most expensive product for each model year while still allowing visibility to all data?
SELECT *
FROM production.products
ORDER BY model_year ASC, list_price DESC;

-- Ordinal position sort using ORDER BY
-- Ordinal position = the order/position of the select values
-- What is the most expensive product for each model year with product_id as the traceable identifier?
SELECT product_id, model_year, list_price
FROM production.products
ORDER BY 2 ASC, 3 DESC;

-- ORDER BY can work with columns not passed into the final output table
-- What is the list price to model year look like while using product_id for traceability, but not using Product Name for less cluttered data?
SELECT product_id, model_year, list_price
FROM production.products
ORDER BY product_name ASC;

-- ORDER BY using expressions
-- What are our most lengthy or complicated product names?
SELECT product_name
from production.products
ORDER BY LEN(product_name) DESC;