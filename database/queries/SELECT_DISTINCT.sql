-- SELECT DISTINCT will select only the unique values according the the passed in columns

-- What cities do we have customers in?
-- Step 0 dataset with no distinct use
SELECT city
FROM sales.customers
ORDER BY city ASC;

-- Step 1 dataset with only distinct values
SELECT DISTINCT city
FROM sales.customers
ORDER BY city ASC;

-- SELECT DISTINCT example with multiple columns
SELECT DISTINCT city, state
FROM sales.customers
ORDER BY city, state;

-- GROUP BY might give more flexibility in the script, but DISTINCT can often be more straightforward
-- GROUP BY example:
SELECT city, state, zip_code
FROM sales.customers
GROUP BY city, state, zip_code
ORDER BY city, state, zip_code

-- The same query using DISTINCT
SELECT DISTINCT city, state, zip_code
FROM sales.customers
