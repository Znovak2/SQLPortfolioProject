-- OR combines two Boolean expressions. It returns True when either of the conditions evaluates to TRUE.

-- The following table shows the results of the OR operator when you combine TRUE, FALSE, and UNKNOWN.
--          TRUE	FALSE	UNKNOWN
--  TRUE	TRUE	TRUE	TRUE
--  FALSE	TRUE	FALSE	UNKNOWN
--  UNKNOWN	TRUE	UNKNOWN	UNKNOWN

-- Who are our customers with no email OR phone on record?
SELECT *
FROM sales.customers
WHERE email IS NULL OR phone IS NULL
ORDER BY last_name, first_name;

-- OR can be used multiple times.
-- Who are our customers in California, Georgia and Florida?
SELECT product_name, brand_id
FROM production.products
WHERE brand_id = 1 OR brand_id = 2 OR brand_id = 4
ORDER BY brand_id DESC;
-- OR used multiple times can be replaced by the IN operator.
SELECT product_name, brand_id
FROM production.products
WHERE brand_id IN (1,2,4)
ORDER BY brand_id DESC;


-- What products are in brand id 1 or 2, but either way are over $500.00.
SELECT product_name, brand_id, list_price
FROM production.products
WHERE (brand_id = 1 OR brand_id =2)
    AND list_price > 500
ORDER BY list_price DESC;
