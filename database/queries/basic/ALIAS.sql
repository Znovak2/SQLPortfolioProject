-- Columns can be renamed for easier readability
-- Apostrophes are needed for multi-worded aliases
-- What are our customers full names?
SELECT first_name + ' ' + last_name AS 'Full Name'
FROM sales.customers
ORDER BY first_name;


-- Aliases can be used to set column names for later use in the query
-- What are our brand 1 product prices sorted highest to lowest price?
SELECT product_name 'Product Name', list_price 'MSRP'
FROM production.products
WHERE brand_id = '1'
ORDER BY 'MSRP' DESC;

-- A table can be given an alias, which is known as a correlation name or range variable.
-- Can be set with or without 'AS'.
-- This is very helpful in JOIN statements for readability
SELECT sales.customers.customer_id, first_name, last_name, order_id
FROM sales.customers
INNER JOIN sales.orders ON sales.orders.customer_id = sales.customers.customer_id;
-- Can be rewritten as:
SELECT c.customer_id, first_name, last_name, order_id
FROM sales.customers c
INNER JOIN sales.orders o ON o.customer_id = c.customer_id;
