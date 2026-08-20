-- The following NULL comparison are "UNKOWN"
-- NULL = 0
-- NULL <> 0
-- NULL > 0
-- NULL = NULL

-- We need to identify our customers who do not have phone numbers recorded in the customers table.
SELECT customer_id, first_name, last_name, phone
FROM sales.customers
WHERE phone = NULL
ORDER BY first_name, last_name;
-- The phone WHERE predicate evaluates to UNKOWN, so we get an empty result set.
-- We need to use the IS NULL operator to make the rows with no phone numbers evaulate to TRUE.
-- This is done by converting the '=' expression to the 'IS' operant.
SELECT customer_id, phone, first_name, last_name
FROM sales.customers
WHERE phone IS NULL
ORDER BY first_name, last_name;


-- We need qualified customer leads who have phone numbers for outreach.
SELECT customer_id, phone, first_name, last_name
FROM sales.customers
WHERE phone IS NOT NULL
ORDER BY first_name, last_name;
