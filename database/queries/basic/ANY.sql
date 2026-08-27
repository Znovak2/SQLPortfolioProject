-- The ANY operator is a logical operator that compares a scalar value with a single-column set of values returned by a subquery.
-- SOME operator is equivalent to the ANY operator

-- Q: What products have ever been ordered twice in a single sales order. This can show potential Wholesale opportunities.
SELECT
    product_name,
    list_price
FROM
    production.products p
WHERE
    product_id = ANY(
        SELECT product_id
        FROM sales.order_items i
        WHERE quantity >= 2
    )
ORDER BY list_price ASC;
