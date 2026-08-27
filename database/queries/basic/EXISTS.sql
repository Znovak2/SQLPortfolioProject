-- EXISTS is an operator which will evaluate as TRUE as soon as one value is returned.
-- NULL values are still considered a return and will evaluate the EXISTS statement as TRUE.

-- EXISTS with a subquery returns NULL example
-- Q: Who are all our customers?
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    EXISTS (SELECT NULL)
ORDER BY
    last_name,
    first_name;
-- When a single NULL value is returned (perhaps a missing phone number), the rest of the statement is initiated.

-- EXISTS with a correlated subquery example
-- Q: 
