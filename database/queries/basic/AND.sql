-- AND is a logical operator that allows the combination of two Boolean expressions.
-- AND returns TRUE when both expressions are evaluated to TRUE.

-- The below table shows the results when you combine TRUE, FALSE, and UNKOWN values using the AND operator.
--          TRUE	FALSE	UNKNOWN
-- TRUE	    TRUE	FALSE	UNKNOWN
-- FALSE	FALSE	FALSE	FALSE
-- UNKNOWN	UNKNOWN	FALSE	UNKNOWN

-- Find all customers who have no phone or email in the customers table
SELECT customer_id, phone, first_name, last_name
FROM sales.customers
WHERE phone IS NULL
    AND email IS NULL
ORDER BY last_name, first_name;

-- What items are in category 1, brand 1, and under $300.00.
SELECT *
FROM production.products
WHERE 1=1 -- This simple evaluation can allow the chaining of AND statements as needed more easily.
    AND category_id = 1
    AND brand_id = 1
    AND list_price < 300
ORDER BY list_price DESC;

-- When using AND with OR within a WHERE clause, the AND operator always gets evaluated first.
-- What are items from brand 1 or 2 and are $300.00 or higher?
SELECT *
FROM production.products
WHERE brand_id = 1 OR brand_id = 2
AND list_price >= 300.00
ORDER BY brand_id ASC;
-- The above statement is stringing the brand_id = 2 with the AND clause, while excluding brand_id = 1.
-- To fix this, parenthesis can be used.
SELECT *
FROM production.products
WHERE (brand_id = 1 OR brand_id = 2)
AND list_price >= 300.00
ORDER BY brand_id ASC;
-- You can see, product_id '95' is removed from the query result set due to the refined logic.
