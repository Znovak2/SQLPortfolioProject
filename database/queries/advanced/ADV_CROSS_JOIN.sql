-- A cross join allows you to combine rows from the first table with every row of the second table. In other words, it returns the Cartesian product of two tables.

-- Q: What products have no sales at a per-store granularity?
SELECT
    s.store_id,
    p.product_id,
    ISNULL(sales, 0) sales
FROM
    sales.stores s
CROSS JOIN production.products p
LEFT JOIN (
    SELECT s.store_id, p.product_id, SUM (quantity * i.list_price) sales
    FROM sales.orders o
    INNER JOIN sales.order_items i ON i.order_id = o.order_id -- Gets order details
    INNER JOIN sales.stores s ON s.store_id = o.store_id -- Gets store details
    INNER JOIN production.products p ON p.product_id = i.product_id -- Gets product details
    GROUP BY s.store_id, p.product_id -- Reduces the granularity
) c
    ON c.store_id = s.store_id
        AND c.product_id = p.product_id -- Joins store with the product info
WHERE
    sales IS NULL -- Finds zero sale items
ORDER BY
    product_id,
    store_id;
