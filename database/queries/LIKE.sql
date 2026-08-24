-- Expression evaluation based on passed characters
-- Wildcard string connotation can be used
-- % , _ , [], ^
-- = equal, != not equal

-- What customers of our's have a last name which starts with 'G'?
SELECT customer_id, last_name, first_name
FROM sales.customers
WHERE last_name
    LIKE 'G%'
ORDER BY customer_id;

-- What customers of our's have a last name which ends with "es"?
SELECT customer_id, last_name, first_name
FROM sales.customers
WHERE last_name
    LIKE '%es'
ORDER BY customer_id;

-- What products of ours have "Women" in the product name?
SELECT product_name
FROM production.products
WHERE product_name LIKE '%Women%'
ORDER BY product_name;

-- the underscore '_' wildcard will evaulate true for any character value.
-- What products of ours have Women or Woman in the product name using the '_' wildcard.
SELECT product_name
FROM production.products
WHERE product_name LIKE '%_omen%'
ORDER BY product_name;

-- List of characters [] wildcard
-- What customer's do we have which last names start with 'A' or 'E'?
SELECT customer_id, last_name, first_name
FROM sales.customers
WHERE last_name LIKE '[AE]%'
ORDER BY last_name;

-- Range of Characters
-- What customers do we have which last names start with A through Z.
SELECT customer_id, last_name, first_name
FROM sales.customers
WHERE last_name LIKE '[A-W]%'
ORDER BY last_name;

-- Carat in a range is interepreted as NOT
-- What customers last names which does not start with A through W?
SELECT customer_id, last_name, first_name
FROM sales.customers
WHERE last_name LIKE '[^A-W]%'
ORDER BY last_name;
