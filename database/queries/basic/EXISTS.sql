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
-- Q: Which customers placed more than 2 orders?
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS ( -- If the customer_id returns a blank result set from this inner query, the customer_id is not returned to the outer query.
        SELECT COUNT(*)
        FROM sales.orders o
        WHERE customer_id = c.customer_id
        GROUP BY customer_id
        HAVING COUNT(*) > 2
    )
ORDER BY last_name, first_name;

-- EXISTS versus IN
-- EXISTS and IN are similar in functionality, can have problems with "NOT".
-- Often, NOT EXISTS is more robust than NOT IN; this is due to the potential of NULL values.
-- NOT IN: SQL's three-valued logic (TRUE, FALSE, UNKNOWN) makes comparisons involving NULL evaluate as UNKNOWN; NOT EXISTS does not have the same problem since NULL values evaulate as TRUE in EXISTS.
-- Q: Which products have never been ordered using 'IN'?

SELECT
    product_id,
    product_name
FROM
    production.products
WHERE
    product_id NOT IN (
        SELECT product_id
        FROM sales.order_items
    );
-- Q: Which products have never been ordered using 'EXISTS'?
SELECT
    p.product_id,
    p.product_name
FROM
    production.products p
WHERE
    NOT EXISTS (
        SELECT 1
        FROM sales.order_items i
        WHERE i.product_id = p.product_id
    );
-- Result: Both queries returned the same dataset since NULL values did not impact our data.
