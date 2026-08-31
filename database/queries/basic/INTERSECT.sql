-- INTERSECT combines result sets of two or more queries and returns distinct rows that are output by both queries.

-- Q: Which products have actually been ordered?
SELECT
    product_id
FROM
    production.products
INTERSECT
SELECT
    product_id
FROM
    sales.order_items
ORDER BY
    product_id;
