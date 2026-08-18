-- Basic use of SELECT statement
SELECT first_name, last_name, email
FROM sales.customers;

-- Use shorthand to select all columns
SELECT *
FROM sales.customers;

-- Filtering with WHERE clause
SELECT *
FROM sales.customers
WHERE state = 'CA';

-- Sorting with ORDER BY clause
SELECT *
FROM sales.customers
WHERE state = 'CA'
ORDER BY first_name;

-- Grouping with GROUP BY clause
SELECT
    city,
    COUNT (*)
FROM
    sales.customers
WHERE
    state = 'CA'
GROUP BY
    city
ORDER BY
    city;

-- Filtering groups using the HAVING clause
SELECT
    city,
    COUNT (*)
FROM
    sales.customers
WHERE
    state = 'CA'
GROUP BY
    city
HAVING  -- Filters groups compared to WHERE clause which filters rows
    COUNT (*) > 10
ORDER BY
    city;
